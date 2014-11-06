/* xplico.c
 * Main program
 *
 * $Id: xplico.c,v 1.17 2007/11/14 19:01:08 costa Exp $
 *
 * Xplico - Internet Traffic Decoder
 * By Gianluca Costa <g.costa@xplico.org>
 * Copyright 2007 Gianluca Costa & Andrea de Franceschi. Web: www.xplico.org
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

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/time.h>

#include "log.h"
#include "dis_mod.h"
#include "flow.h"
#include "capture.h"
#include "dispatch.h"
#include "version.h"
#include "dmemory.h"
#include "fthread.h"
#include "report.h"
#include "strutil.h"
#include "config_param.h"
#include "embedded.h"
#include "grp_rule.h"
#include "grp_flows.h"
#include "dnsdb.h"
#include "geoiploc.h"
#include "configs.h"


extern int LogDirName(char *file_cfg); /* log.c */
extern int LogToScreen(bool enb);      /* log.c */
extern void CommonLink(void);          /* common/link.c */
extern void DissectorLink(void);       /* dissector/link.c */


static void Usage(char *name, bool capt, char *mod)
{
    char *rname;

    rname = strrchr(name, '/');
    if (rname == NULL) {
        rname = name;
    }
    else {
        rname++;
    }

    printf("\n");
    if (capt == FALSE) {
#ifdef XPL_CHECK_CODE
        printf("usage: %s [-v] [-c <config_file>] [-h] [-g] [-l] [-i <prot>] -m <capute_module>\n", rname);
#else
        printf("usage: %s [-v] [-c <config_file>] [-h] [-g] [-i <prot>] -m <capute_module>\n", rname);
#endif
    }
    else {
#ifdef XPL_CHECK_CODE
        printf("usage: %s [-v] [-c <config_file>] [-h] [-g] [-l] [-i <prot>] -m %s %s\n", rname, mod, CapOptions());
#else
        printf("usage: %s [-v] [-c <config_file>] [-h] [-g] [-i <prot>] -m %s %s\n", rname, mod, CapOptions());
#endif
    }
    printf("\t-v version\n");
    printf("\t-c config file\n");
    printf("\t-h this help\n");
    printf("\t-i info of protocol 'prot' \n");
    printf("\t-g display graph-tree of protocols\n");
#ifdef XPL_CHECK_CODE
    printf("\t-l print all log in the screen\n");
#endif
    printf("\t-m capture type module\n");
    if (capt == TRUE) {
        printf("\t----- module params -----\n");
        CapOptionsHelp();
    }
    printf("\tNOTE: parameters MUST respect this order!\n");
    printf("\n");
}


static int CoreLog(const char *file_cfg)
{
    FILE *fp;
    int nl;
    char buffer[CFG_LINE_MAX_SIZE];
    char bufcpy[CFG_LINE_MAX_SIZE];
    char mask[CFG_LINE_MAX_SIZE];
    char *param;
    unsigned short logm;
    int res;

    /* find directory location of module from config file */
    fp = fopen(file_cfg, "r");
    if (fp == NULL) {
        LogPrintf(LV_ERROR, "Config file can't be opened");
        return -1;
    }

    nl = 0;
    while (fgets(buffer, CFG_LINE_MAX_SIZE, fp) != NULL) {
        nl++;
        /* check all line */
        if (strlen(buffer)+1 == CFG_LINE_MAX_SIZE) {
            LogPrintf(LV_ERROR, "Config file line more length to %d characters", CFG_LINE_MAX_SIZE);
            fclose(fp);

            return -1;
        }
        /* check if line is a comment */
        if (!CfgParIsComment(buffer)) {
            /* log mask */
            param = strstr(buffer, CFG_PAR_CORE_LOG"=");
            if (param != NULL) {
                res = sscanf(param, CFG_PAR_CORE_LOG"=%s %s", mask, bufcpy);
                logm = LV_BASE;
                if (res > 0) {
                    if (res == 2 && !CfgParIsComment(bufcpy)) {
                        LogPrintf(LV_ERROR, "Config param error in line %d. Unknow param: %s", nl, bufcpy);
                        fclose(fp);

                        return -1;
                    }
                    logm |= CfgParLogMask(mask, nl);
                }
                else {
                    LogPrintf(LV_ERROR, "Config param error in line %d. Unknow param: %s", nl, buffer);
                    fclose(fp);

                    return -1;
                }
                /* set mask */
                LogSetMask(LOG_COMPONENT, logm);
            }
        }
    }
    fclose(fp);

    return 0;
}


int main(int argc, char *argv[])
{
    bool graph, capt, help, info, log, cfg_f, version;
    int c;
    char config_file[512];
    char module_name[128];
    char info_prot[64];
    struct timeval start_t, end_t;
    time_t end_to;
    extern char *optarg;
    extern int optind, optopt;

    graph = FALSE;
    help = FALSE;
    capt = FALSE;
    info = FALSE;
    log = FALSE;
    cfg_f = FALSE;
    version = FALSE;

    gettimeofday(&start_t, NULL);
    module_name[0] = '\0';
    strcpy(config_file, XP_DEFAULT_CFG); /* default */
    while (capt == FALSE && (c = getopt(argc, argv, "vc:hi:glm:")) != -1) {
        switch (c) {
        case 'v':
            printf("xplico %d.%d.%d\n", XPLICO_VER_MAG, XPLICO_VER_MIN, XPLICO_VER_REV);
            version = TRUE;
            break;

        case 'c':
            sprintf(config_file, "%s", optarg);
            cfg_f = TRUE;
            break;

        case 'g':
            graph = TRUE;
            break;
            
        case 'h':
            help = TRUE;
            break;

        case 'i':
            info = TRUE;
            sprintf(info_prot, "%s", optarg);
            break;

        case 'm':
            capt = TRUE;
            sprintf(module_name, "%s", optarg);
            break;
            
        case 'l':
            log = TRUE;
            break;

        case '?':
            if (capt == FALSE) {
                printf("Error: unrecognized option: -%c\n", optopt);
                Usage(argv[0], capt, module_name);
                exit(2);
            }
            break;
        }
    }

    if (!capt && version)
        return 0;

    /* version and copyright */
    printf("xplico v%d.%d.%d\n", XPLICO_VER_MAG, XPLICO_VER_MIN, XPLICO_VER_REV);
    printf("%s\n", XPLICO_CR);
#ifdef GEOIP_LIBRARY
    printf("%s\n", XPLICO_GEOP_LICENSE);
#endif

    /* help */
    if (help && !capt) {
        Usage(argv[0], capt, module_name);
        return 0;
    }
    
    /* common functions initialization (embeded, strutil,...)*/
    CommonLink();

    /* common dissector linking funcions */
    DissectorLink();

    /* log dir */
    if (LogDirName(config_file) == -1) {
        if (cfg_f == FALSE) {
            /* change configuration file */
            strcpy(config_file, "/opt/xplico/cfg/xplico_cli.cfg"); /* next default */
            if (LogDirName(config_file) == -1) {
                printf("error: unable to open files %s and %s\n", XP_DEFAULT_CFG, config_file);
                printf("Configuration file execution error (see above).\n");
                return -1;
            }
            else {
                printf("Configuration file (%s) found!\n", config_file);
            }
        }
        else {
             printf("error: unable to open configuraion file %s\n", config_file);
             return -1;
        }
    }
    else {
        printf("Configuration file (%s) found!\n", config_file);
    }

    /* log screen setting */
    LogToScreen(log);

    /* core log mask */
    if (CoreLog(config_file)  == -1) {
        LogPrintf(LV_FATAL, "Log setup failed");
        exit(-1);
    }

    /* memory function initialization  */
    if (DMemInit() == -1) {
        LogPrintf(LV_FATAL, "Memory initialization failed");
        exit(-1);
    }
    
    /* Thread function initialization */
    FthreadInit();

    /* load capture module */
    if (capt == TRUE) {
        if (CapInit(config_file, module_name) == -1) {
            LogPrintf(LV_FATAL, "Load 'capture' module failed");
            exit(-1);
        }
    }

    /* help */
    if (help) {
        Usage(argv[0], capt, module_name);
        return 0;
    }

    /* load modules */
    if (DisModLoad(config_file) == -1) {
        LogPrintf(LV_FATAL, "Load modules failed");
        exit(-1);
    }

    /* load dispatch */
    if (DispatchInit(config_file)  == -1) {
        LogPrintf(LV_FATAL, "Load 'dispatch' module failed");
        exit(-1);
    }

    /* initializatiion modules */
    if (DisModInit() == -1) {
        LogPrintf(LV_FATAL, "Modules initialization failed");
        exit(-1);
    }
    
    /* protocol administrator init */
    if (ProtInit(config_file) == -1) {
        LogPrintf(LV_FATAL, "Inizialization Protocol internal structures failed");
        exit(-1);
    }

    /* flow administrator init */
    if (FlowInit() == -1) {
        LogPrintf(LV_FATAL, "Inizialization Flow internal structures failed");
        exit(-1);
    }

    /* group flow administrator init */
    if (GrpInit() == -1) {
        LogPrintf(LV_FATAL, "Inizialization group internal structures failed");
        exit(-1);
    }    
    
    /* group rules administrator init */
    if (GrpRuleInit() == -1) {
        LogPrintf(LV_FATAL, "Inizialization group-rule structures failed");
        exit(-1);
    }

    /* Dns db init */
    DnsDbInit();

    /* Geo Ip localization init */
    if (GeoIPLocInit() == -1) {
        printf("Download GeoLiteCity.dat from http://geolite.maxmind.com/download/geoip/database/ and gunzip it into /opt/xplico/\n");
        if (!(help || capt == FALSE))
            sleep(2);
    }
    else {
        printf("GeoLiteCity.dat found!\n");
    }

    /* graph of protocols */
    if (graph) {
        DisModProtGraph();
    }
    
    /* protcol information & pei components */
    if (info) {
        DisModProtInfo(info_prot);
        return 0;
    }
    
    /* check */
    if (capt == FALSE) {
        Usage(argv[0], capt, module_name);
        return 0;
    }

    /* report thread/protocol: initilalization */
    ReportInit();

    /* start */
    if (CapMain(argc, argv) == -1) {
        Usage(argv[0], capt, module_name);
        return -1;
    }

    /* close all flow still open */
    LogPrintf(LV_INFO, "Close all");
    FlowCloseAll();

    /* wait completitions */
    end_to = time(NULL) + XP_END_TO;
    while (FthreadRunning() != 0) {
        if (end_to < time(NULL)) {
            LogPrintf(LV_INFO, "Thread runnning: %d", FthreadRunning());
            LogPrintf(LV_INFO, "%d flow still open", FlowNumber());
            LogPrintf(LV_FATAL, "There is a dissector in infinite loop");
            FlowLoopLog();
            fflush(NULL);
            printf("\n---- EXIT for infinte loop, see log ----\n\n");
            exit(-1);
        }
        ReportSplash();
        sleep(1);
    }

    /* check number of flow still open */
    if (FlowNumber() != 0) {
        LogPrintf(LV_OOPS, "%d flow still open", FlowNumber());
        ReportSplash();
        FlowDebOpen();
    }

    /* close modules dissectors */
    DisModClose();

    /* close dispacher */
    DispatchEnd();

    gettimeofday(&end_t, NULL);
    
    LogPrintf(LV_STATUS, "End. Total elaboration time:  %lus %luus", end_t.tv_sec-start_t.tv_sec+(1000000+end_t.tv_usec-start_t.tv_usec)/1000000, (1000000+end_t.tv_usec-start_t.tv_usec)%1000000);
    ReportSplash();
    printf("Total elaboration time: %lus\n", end_t.tv_sec-start_t.tv_sec+(1000000+end_t.tv_usec-start_t.tv_usec)/1000000);

    return 0;
}
