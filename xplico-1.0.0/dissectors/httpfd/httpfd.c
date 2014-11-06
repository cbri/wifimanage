/* httpfd.c
 * HTTP file download dissector
 *
 * $Id: $
 *
 * Xplico - Internet Traffic Decoder
 * By Gianluca Costa <g.costa@xplico.org>
 * Copyright 2007-2010 Gianluca Costa & Andrea de Franceschi. Web: www.xplico.org
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

#include <pcap.h>
#include <arpa/inet.h>
#include <string.h>

#include "proto.h"
#include "dmemory.h"
#include "etypes.h"
#include "log.h"
#include "pei.h"
#include "http.h"
#include "fileformat.h"

#define  HTTPFD_FILE_PATH          512

static int prot_id;
static int pei_url_id;
static int pei_file_id;
static int pei_range_id;
static int pei_content_type;

static PktDissector HttpPktDis;  /* this functions create the http pei for all http packets */

static packet* HttpFdDissector(packet *pkt)
{
    http_msg *msg;
    pei *ppei;
    pei_component *cmpn;
    char strbuf[HTTPFD_FILE_PATH];
    char new_path[HTTPFD_FILE_PATH];
    char *orig_file;
    
    ppei = NULL;
    
    /* display info */
    msg = (http_msg *)pkt->data;
    LogPrintf(LV_DEBUG, "HTTPfd HttpFdDissector");

#ifdef XPL_CHECK_CODE
    if (msg->serial == 0) {
        LogPrintf(LV_FATAL, "HTTPfd HttpFdDissector serial error");
        exit(-1);
    }
#endif
    orig_file = msg->res_body_file;
    /* encoding */
    if (msg->content_encoding[1] != NULL) {
        /* compressed */
        sprintf(new_path, "%s.dec", msg->res_body_file);
        FFormatUncompress(msg->content_encoding[1], msg->res_body_file, new_path);
        DMemFree(orig_file);
        orig_file = new_path;
        remove(msg->res_body_file);
    }
    msg->res_body_file = NULL;
    
    /* compose pei (to send at manipulator) */
    PeiNew(&ppei, prot_id);
    PeiCapTime(ppei, pkt->cap_sec);
    PeiMarker(ppei, pkt->serial);
    PeiStackFlow(ppei, pkt->stk);
    
    /*   url */
    PeiNewComponent(&cmpn, pei_url_id);
    PeiCompCapTime(cmpn, msg->start_cap);
    PeiCompCapEndTime(cmpn, msg->end_cap);
    PeiCompAddStingBuff(cmpn, msg->uri);
    PeiAddComponent(ppei, cmpn);
    
    /*   file */
    PeiNewComponent(&cmpn, pei_file_id);
    PeiCompCapTime(cmpn, msg->start_cap);
    PeiCompCapEndTime(cmpn, msg->end_cap);
    PeiCompAddFile(cmpn, "Http file", orig_file, 0);
    if (msg->error)
        PeiCompError(cmpn, ELMT_ER_PARTIAL);
    PeiAddComponent(ppei, cmpn);
    
    /*   range */
    if (msg->rsize != 0) {
        PeiNewComponent(&cmpn, pei_range_id);
        PeiCompCapTime(cmpn, msg->start_cap);
        PeiCompCapEndTime(cmpn, msg->end_cap);
        sprintf(strbuf, "%lu-%lu/%lu", msg->rbase, msg->rend, msg->rsize);
        PeiCompAddStingBuff(cmpn, strbuf);
        PeiAddComponent(ppei, cmpn);
    }

    /* content_type */
    if (msg->content_type[1] != NULL) {
        PeiNewComponent(&cmpn, pei_content_type);
        PeiCompCapTime(cmpn, msg->start_cap);
        PeiCompCapEndTime(cmpn, msg->end_cap);
        PeiCompAddStingBuff(cmpn, msg->content_type[1]);
        PeiAddComponent(ppei, cmpn);
    }
    else if (msg->content_type[0] != NULL) {
        PeiNewComponent(&cmpn, pei_content_type);
        PeiCompCapTime(cmpn, msg->start_cap);
        PeiCompCapEndTime(cmpn, msg->end_cap);
        PeiCompAddStingBuff(cmpn, msg->content_type[0]);
        PeiAddComponent(ppei, cmpn);
    }
    
    /* remove file */
    HttpMsgRemove(msg);
    
    /* insert pei */
    PeiIns(ppei);

    /* free memory */
    if (orig_file != new_path)
        msg->res_body_file = orig_file;
    HttpMsgFree(msg);
    PktFree(pkt);

    return NULL;
}


int DissecRegist(const char *file_cfg)
{
    proto_dep dep;
    pei_cmpt peic;

    memset(&dep, 0, sizeof(proto_dep));
    memset(&peic, 0, sizeof(pei_cmpt));

    /* protocol name */
    ProtName("Http file download", "httpfd");

    /* http dependence */
    dep.name = "http";
    dep.attr = "http.content_range";
    dep.type = FT_STRING;
    dep.op = FT_OP_CNTD;
    dep.val.str =  DMemMalloc(2);
    strcpy(dep.val.str, "-");
    ProtDep(&dep);

    peic.abbrev = "url";
    peic.desc = "Uniform Resource Locator";
    ProtPeiComponent(&peic);

    peic.abbrev = "file";
    peic.desc = "File";
    ProtPeiComponent(&peic);

    peic.abbrev = "range";
    peic.desc = "File range";
    ProtPeiComponent(&peic);

    peic.abbrev = "content_type";
    peic.desc = "Content Type";
    ProtPeiComponent(&peic);

    /* dissectors registration */
    ProtDissectors(HttpFdDissector, NULL, NULL, NULL);

    return 0;
}


int DissectInit(void)
{
    int http_id;
    
    prot_id = ProtId("httpfd");

    /* Http pei generator */
    HttpPktDis = NULL;
    http_id = ProtId("http");
    if (http_id != -1) {
        HttpPktDis = ProtPktDefaultDis(http_id);
    }

    /* pei id */
    pei_url_id = ProtPeiComptId(prot_id, "url");
    pei_file_id = ProtPeiComptId(prot_id, "file");
    pei_range_id = ProtPeiComptId(prot_id, "range");
    pei_content_type = ProtPeiComptId(prot_id, "content_type");

    return 0;
}
