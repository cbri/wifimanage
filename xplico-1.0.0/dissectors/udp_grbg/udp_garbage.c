/* udp_garbage.c
 * Dissector to group together packet of udp flow that haven't a specific dissector
 *
 * $Id:  $
 *
 * Xplico - Internet Traffic Decoder
 * By Gianluca Costa <g.costa@xplico.org>
 * Copyright 2007-2011 Gianluca Costa & Andrea de Franceschi. Web: www.xplico.org
 *
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */

#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>
#include <pcap.h>
#include <ctype.h>
#include <dirent.h>

#include "proto.h"
#include "dmemory.h"
#include "etypes.h"
#include "flow.h"
#include "log.h"
#include "dnsdb.h"
#include "udp_garbage.h"
#include "pei.h"

#define GRB_FILE           0  /* to put (or not) data in to a file */
#define UDP_GRB_TMP_DIR    "udp_grb"

static int ppp_id;
static int eth_id;
static int ip_id;
static int ipv6_id;
static int udp_id;
static int ip_src_id;
static int ip_dst_id;
static int ipv6_src_id;
static int ipv6_dst_id;
static int port_src_id;
static int port_dst_id;
static int udp_grb_id;
static volatile int serial = 0;

/* pei id */
static int pei_l7protocol_id;
static int pei_txt_id;
static int pei_size_id;

static volatile unsigned int incr;
static l7prot *prot_list;


static int L7hex2dec(char c, char *filename)
{
  switch (c){
    case '0' ... '9':
      return c - '0';

    case 'a' ... 'f':
      return c - 'a' + 10;

    case 'A' ... 'F':
      return c - 'A' + 10;

    default:
        LogPrintf(LV_FATAL, "Bad hex digit %c (file:%s), in regular expression!", c, filename);
        printf("Error: Bad hex digit %c (file:%s), in regular expression!", c, filename);
        exit(-1);
  }
}


static char *L7Preprocess(const char *s, char *filename) 
{
    char *result = (char *)xmalloc(strlen(s) + 1);
    unsigned int sindex = 0, rindex = 0;
    
    while( sindex < strlen(s) ) {
        if( sindex + 3 < strlen(s) && s[sindex] == '\\' && s[sindex+1] == 'x' && 
            isxdigit(s[sindex + 2]) && isxdigit(s[sindex + 3]) ){
            
            result[rindex] = L7hex2dec(s[sindex + 2], filename)*16 + L7hex2dec(s[sindex + 3], filename);
            
            switch (result[rindex]) {
            case '$':
            case '(':
            case ')':
            case '*':
            case '+':
            case '.':
            case '?':
            case '[':
            case ']':
            case '^':
            case '|':
            case '{':
            case '}':
            case '\\':
                LogPrintf(LV_WARNING, "egexp contains a regexp control character, %c\nI recommend that you write this as %c or \\%c depending on what you meant.\n", result[rindex], result[rindex], result[rindex]);
                break;
            case '\0':
                LogPrintf(LV_WARNING, "null (\\x00) in layer7 regexp.\nA null terminates the regexp string!\n");
                break;
            default:
                break;
            }
            sindex += 3; /* 4 total */
        }
        else
            result[rindex] = s[sindex];
        
        sindex++; 
        rindex++;
    }
    result[rindex] = '\0';
    
    return result;
}


static void LoadL7Pattern(char *base, char *filename)
{
    FILE *fp;
    l7prot *proto;
    char path[UDP_GRB_FILENAME_PATH_SIZE];
    char buffer[1024*100];
    char *pre;
    bool regx;

    proto = (l7prot *)xmalloc(sizeof(l7prot));
    if (proto == NULL)
        return;
    else
        memset(proto, 0, sizeof(l7prot));
    
    snprintf(path, sizeof(path), "%s/%s", base, filename);
    fp = fopen(path, "r");
    regx = FALSE;
    if (fp != NULL) {
        while (fgets(buffer, sizeof(buffer), fp) != NULL) {
            if ((buffer[0] != '#') && (buffer[0] != ' ') && (buffer[0] != '\n')
                && (buffer[0] != '\r') && (buffer[0] != '\t')) {
                buffer[strlen(buffer)-1] = '\0';
                
                if (proto->name == NULL)
                    proto->name = strdup(buffer);
                else {
                    if (regx == FALSE) {
                        //proto->regex = pcre_compile(buffer, PCRE_CASELESS, &errptr, &erroffset, NULL);
                        //if (proto->regex == NULL) {
                        pre = L7Preprocess(buffer, filename);
                        if (regcomp(&proto->regex, pre, REG_EXTENDED | REG_ICASE | REG_NOSUB) != 0) {
                            if (proto->name != NULL)
                                xfree(proto->name);
                            xfree(proto);
                            xfree(pre);
                            LogPrintf(LV_WARNING, "Invalid pattern. File: %s", path);
                            return;
                        }
                        xfree(pre);
                        regx = TRUE;
                        break;
                    }
                }
            }
        }
        
        fclose(fp);
    }
    else
        LogPrintf(LV_WARNING, "Unable to read pattern file %s", path);
    
    if (proto->name == NULL || regx == FALSE) {
        if (proto->name != NULL) {
            LogPrintf(LV_WARNING, "No pattern. File: %s", path);
            free(proto->name);
        }
        xfree(proto);
        return;
    }

    /* add to list */
    proto->prio = 0;
    proto->next = prot_list;
    prot_list = proto;
    
    return;
}


static const char *L7Match(unsigned char *dat, unsigned int size)
{
    l7prot *check = prot_list;
    int rc;

    if (size == 0)
        return NULL;
    
    if (size > UDP_GRB_L7_SIZE_LIM)
        size = UDP_GRB_L7_SIZE_LIM;

    while (check) {
        rc = regexec(&check->regex, (char *)dat, 0, NULL, 0);
        if (rc == 0) {
            check->prio++;
            
            return check->name;
        }

        check = check->next;
    }
    
    return NULL;
}


static bool UdpGrbCheck(int flow_id)
{
    if (FlowPktNum(flow_id) >  UDP_GRB_PKT_LIMIT || FlowIsClose(flow_id) == TRUE) {
        return TRUE;
    }

    return FALSE;
}


static bool UdpGrbMajorityText(unsigned char *dat, unsigned int size)
{
    unsigned int perc, i, j;

    if (size == 0)
        return FALSE;

    perc = (size * UDP_GRB_PERCENTAGE)/100;
    
    j = 0;
    for (i=0; i!=size && j!=perc; i++) {
        if (0x1F<dat[i] && dat[i]<0x7F)
            j++;
    }
    if (j == perc)
        return TRUE;
    
    return FALSE;
}


static void UdpGrbText(FILE *fp, unsigned char *dat, unsigned int size)
{
    unsigned int i, j;
    
    j = 0;
    for (i=0; i!=size; i++) {
        if (dat[i]<0x7F)
            dat[j++] = dat[i];
    }
    fwrite(dat, 1, j, fp);
}


static void GrbPei(pei *ppei, const char *prot_name, size_t size, char *txt_file, time_t *cap_sec, time_t *end_cap)
{
    char val[UDP_GRB_FILENAME_PATH_SIZE];
    pei_component *cmpn;

    /* pei components */
    PeiNewComponent(&cmpn, pei_l7protocol_id);
    PeiCompCapTime(cmpn, *cap_sec);
    PeiCompCapEndTime(cmpn, *end_cap);
    PeiCompAddStingBuff(cmpn, prot_name);
    PeiAddComponent(ppei, cmpn);
    
    if (txt_file != NULL) {
        PeiNewComponent(&cmpn, pei_txt_id);
        PeiCompCapTime(cmpn, *cap_sec);
        PeiCompCapEndTime(cmpn, *end_cap);
        PeiCompAddFile(cmpn, "Text", txt_file, 0);
        PeiAddComponent(ppei, cmpn);
    }

    sprintf(val, "%ul", size);
    PeiNewComponent(&cmpn, pei_size_id);
    PeiCompCapTime(cmpn, *cap_sec);
    PeiCompCapEndTime(cmpn, *end_cap);
    PeiCompAddStingBuff(cmpn, val);
    PeiAddComponent(ppei, cmpn);
}


packet* UdpGrbDissector(int flow_id)
{
    packet* pkt;
    const pstack_f *udp, *ip;
    ftval port_src, port_dst, ip_src, ip_dst;
    struct in_addr ip_addr;
    char ips_str[30], ipd_str[30];
    bool ipv4;
    int count;
    int threshold;
    bool txt_data;
    FILE *txt_fp;
    char txt_file[UDP_GRB_FILENAME_PATH_SIZE];
    unsigned char *thrs;
    pei *ppei;
    time_t cap_sec, end_cap;
#if GRB_FILE
    int fd_pcap;
    char filename[256];
    int prot;
    struct pcap_file_header fh;
    struct pcap_pkthdr pckt_header;
#endif
    const char *l7prot_type;
    size_t flow_size;

    LogPrintf(LV_DEBUG, "UDP garbage id: %d", flow_id);

    udp = FlowStack(flow_id);
    ip = ProtGetNxtFrame(udp);
    ProtGetAttr(udp, port_src_id, &port_src);
    ProtGetAttr(udp, port_dst_id, &port_dst);
    ipv4 = FALSE;
    if (ProtFrameProtocol(ip) == ip_id)
        ipv4 = TRUE;
    if (ipv4) {
        ProtGetAttr(ip, ip_src_id, &ip_src);
        ProtGetAttr(ip, ip_dst_id, &ip_dst);
        ip_addr.s_addr = ip_src.uint32;
        LogPrintf(LV_DEBUG, "\tSRC: %s:%d", inet_ntoa(ip_addr), port_src.uint16);
        sprintf(ips_str, "%s.%d", inet_ntoa(ip_addr), port_src.uint16);
        ip_addr.s_addr = ip_dst.uint32;
        LogPrintf(LV_DEBUG, "\tDST: %s:%d", inet_ntoa(ip_addr), port_dst.uint16);
        sprintf(ipd_str, "%s.%d", inet_ntoa(ip_addr), port_dst.uint16);
    }
    else
        LogPrintf(LV_DEBUG, "UDP garbage IPv6");

    /* file pcap */
#if GRB_FILE
    sprintf(filename, "%s/udp_%d_grb_%s_%s.pcap", ProtTmpDir(), serial, ips_str, ipd_str);
    serial++;
    fd_pcap = open(filename, O_WRONLY | O_CREAT, 0x01B6);
    memset(&fh, 0, sizeof(struct pcap_file_header));
    fh.magic = 0xA1B2C3D4;
    fh.version_major = PCAP_VERSION_MAJOR;
    fh.version_minor = PCAP_VERSION_MINOR;
    fh.snaplen = 65535;
    if (ProtGetNxtFrame(ip) != NULL) {
        prot = ProtFrameProtocol(ProtGetNxtFrame(ip));
        if (prot== eth_id)
            fh.linktype = DLT_EN10MB;
        else if (prot == ppp_id)
            fh.linktype = DLT_PPP;
        else
            fh.linktype = DLT_RAW;
    }
    if (fd_pcap != -1)
        write(fd_pcap, (char *)&fh, sizeof(struct pcap_file_header));
#endif

    l7prot_type = NULL;
    flow_size = 0;
    count = 0;
    ppei = NULL;
    txt_data = FALSE;
    txt_fp = NULL;
    threshold = 0;
    thrs = xmalloc(UDP_GRB_THRESHOLD);
    pkt = FlowGetPkt(flow_id);
    if (pkt != NULL) {
        /* create pei */
        PeiNew(&ppei, udp_grb_id);
        PeiCapTime(ppei, pkt->cap_sec);
        PeiMarker(ppei, pkt->serial);
        PeiStackFlow(ppei, udp);
        cap_sec = pkt->cap_sec;
    }
    while (pkt != NULL) {
        count++;
        flow_size += pkt->len;
        end_cap = pkt->cap_sec;
#if GRB_FILE
        pckt_header.caplen = pkt->raw_len;
        pckt_header.len = pkt->raw_len;
        pckt_header.ts.tv_sec = pkt->cap_sec;
        pckt_header.ts.tv_usec = pkt->cap_usec;
        if (fd_pcap != -1) {
            write(fd_pcap, (char *)&pckt_header, sizeof(struct pcap_pkthdr));
            write(fd_pcap, (char *)pkt->raw, pkt->raw_len);
        }
#endif
        if (thrs != NULL) {
            /* check stream to find text */
            if (threshold + pkt->len > UDP_GRB_THRESHOLD) {
                if (txt_data == FALSE) {
                    /* protocol type */
                    if (l7prot_type == NULL)
                        l7prot_type = L7Match(thrs, threshold);
                    /* text flow */
                    txt_data = UdpGrbMajorityText(thrs, threshold);
                    if (txt_data == FALSE) {
                        xfree(thrs);
                        thrs = NULL;
                        threshold = 0;
                    }
                    else {
                        sprintf(txt_file, "%s/%s/udp_grb_%lu_%p_%i.txt", ProtTmpDir(), UDP_GRB_TMP_DIR, time(NULL), txt_file, incr++);
                        txt_fp = fopen(txt_file, "w");
                        if (txt_fp != NULL) {
                            UdpGrbText(txt_fp, thrs, threshold);
                            threshold = 0;
                            memcpy(thrs+threshold, pkt->data,  pkt->len);
                            threshold += pkt->len;
                            thrs[threshold] = '\0';
                        }
                        else {
                            LogPrintf(LV_ERROR, "Unable to open file: %s", txt_file);
                            txt_data = FALSE;
                            xfree(thrs);
                            thrs = NULL;
                            threshold = 0;
                        }
                    }
                }
                else {
                    /* protocol type */
                    if (l7prot_type == NULL)
                        l7prot_type = L7Match(thrs, threshold);
                    UdpGrbText(txt_fp, thrs, threshold);
                    threshold = 0;
                    memcpy(thrs+threshold, pkt->data, pkt->len);
                    threshold += pkt->len;
                    thrs[threshold] = '\0';
                }
            }
            else {
                memcpy(thrs+threshold, pkt->data,  pkt->len);
                threshold += pkt->len;
                thrs[threshold] = '\0';
            }
        }
        PktFree(pkt);
        pkt = FlowGetPkt(flow_id);
    }
    if (thrs != NULL) {
        if (txt_data == FALSE) {
            /* protocol type */
            if (l7prot_type == NULL)
                l7prot_type = L7Match(thrs, threshold);
            if (UdpGrbMajorityText(thrs, threshold) == TRUE) {
                sprintf(txt_file, "%s/%s/udp_grb_%lu_%p_%i.txt", ProtTmpDir(), UDP_GRB_TMP_DIR, time(NULL), txt_file, incr++);
                txt_fp = fopen(txt_file, "w");
            }
        }
        if (txt_fp != NULL) {
            UdpGrbText(txt_fp, thrs, threshold);
        }
        xfree(thrs);
    }
    if (l7prot_type == NULL)
        l7prot_type = "unknown";
    if (txt_fp != NULL) {
        fclose(txt_fp);
        /* insert data */
        GrbPei(ppei, l7prot_type, flow_size, txt_file, &cap_sec, &end_cap);
        /* insert pei */
        PeiIns(ppei);
    }
    else {
        /* insert data */
        GrbPei(ppei, l7prot_type, flow_size, NULL, &cap_sec, &end_cap);
        /* insert pei */
        PeiIns(ppei);
    }

    /* end */
#if GRB_FILE
    if (fd_pcap != -1)
        close(fd_pcap);
#endif

    LogPrintf(LV_DEBUG, "UD->%s  garbage... bye bye  fid:%d", l7prot_type, flow_id);

    return NULL;
}


int DissecRegist(const char *file_cfg)
{
    proto_heury_dep hdep;
    pei_cmpt peic;

    memset(&hdep, 0, sizeof(proto_heury_dep));
    memset(&peic, 0, sizeof(pei_cmpt));

    /* protocol name */
    ProtName("UDP garbage", "udp-grb");

    /* dep: ethernet */
    hdep.name = "udp";
    hdep.ProtCheck = UdpGrbCheck;
    ProtHeuDep(&hdep);

    /* PEI components */
    peic.abbrev = "l7prot";
    peic.desc = "L7 protocol march";
    ProtPeiComponent(&peic);

    peic.abbrev = "txt";
    peic.desc = "Text file";
    ProtPeiComponent(&peic);

    peic.abbrev = "size";
    peic.desc = "Flow total size";
    ProtPeiComponent(&peic);

    /* dissectors subdissectors registration */
    ProtDissectors(NULL, UdpGrbDissector, NULL, NULL);

    return 0;
}


int DissectInit(void)
{
    char tmp_dir[256];
    char *dir_pat;
    DIR *dirp;
    struct dirent* dp;

    /* part of file name */
    incr = 0;

    /* info id */
    ppp_id = ProtId("ppp");
    eth_id = ProtId("eth");
    ip_id = ProtId("ip");
    ipv6_id = ProtId("ipv6");
    udp_id = ProtId("udp");
    ip_dst_id = ProtAttrId(ip_id, "ip.dst");
    ip_src_id = ProtAttrId(ip_id, "ip.src");
    ipv6_dst_id = ProtAttrId(ipv6_id, "ipv6.dst");
    ipv6_src_id = ProtAttrId(ipv6_id, "ipv6.src");
    port_dst_id = ProtAttrId(udp_id, "udp.dstport");
    port_src_id = ProtAttrId(udp_id, "udp.srcport");
    udp_grb_id = ProtId("udp-grb");
    
    /* pei id */
    pei_l7protocol_id = ProtPeiComptId(udp_grb_id, "l7prot");
    pei_txt_id = ProtPeiComptId(udp_grb_id, "txt");
    pei_size_id = ProtPeiComptId(udp_grb_id, "size");
    
    /* tmp directory */
    sprintf(tmp_dir, "%s/%s", ProtTmpDir(), UDP_GRB_TMP_DIR);
    mkdir(tmp_dir, 0x01FF);

    /* load regular expressions */
    prot_list = NULL;
    dir_pat = UDP_GRB_L7_PROT_DEFAULT;
    dirp = opendir(dir_pat);
    if (dirp == NULL) {
        dir_pat = UDP_GRB_L7_PROT_INSTALL;
        dirp = opendir(dir_pat);
    }
    if (dirp == NULL) {
        LogPrintf(LV_WARNING, "Unable to read directory '%s'", dir_pat);
        return 0 ;
    }

    while ((dp = readdir(dirp)) != NULL) {
        if (dp->d_name[0] == '.')
            continue;
        else if (strstr(dp->d_name, UDP_GRB_L7_EXTENSION) == NULL)
            continue;
                
        LoadL7Pattern(dir_pat, dp->d_name);
    }
    closedir(dirp);
    
    return 0;
}
