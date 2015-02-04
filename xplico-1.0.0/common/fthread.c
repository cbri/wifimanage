/* fthread.c
 * Funcrion and structure for manage flow thread
 *
 * $Id: fthread.c,v 1.11 2007/06/18 06:14:16 costa Exp $
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

#include <pthread.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>

#include "fthread.h"
#include "flow.h"
#include "log.h"
#include "dmemory.h"


/** internal variables */
static fthrd *volatile fthd_tbl;           /* table of flows thread */
static volatile unsigned long fth_tbl_dim; /* dimension of table */
static volatile unsigned long fthd_num;    /* number of open thread */
static pthread_mutex_t fthd_mux;           /* mutex to access atomicly the tbl */
static pthread_mutex_t fthd_sync_mux;      /* mutex for creation syncronization */
static pthread_attr_t fthd_attr;           /* attribute of thread */


/** internal functions */
static int FthreadElemInit(fthrd *fthd)
{
    fthd->fid = -1;
    fthd->pid = 0;
    fthd->stack = NULL;

    return 0;
}


static int FthreadTblExtend(void)
{
    unsigned long i, len;
    fthrd *new;

    len = fth_tbl_dim+FTHD_TBL_ELEMENT_DELTA;

    new = xrealloc(fthd_tbl, sizeof(fthrd)*(len));
    if (new == NULL)
        return -1;
    
    /* initialize new elements */
    for (i=fth_tbl_dim; i<len; i++) {
        memset(&new[i], 0, sizeof(fthrd));
        FthreadElemInit(&(new[i]));
    }

    fthd_tbl = new;
    fth_tbl_dim = len;

    return 0;
}


int FthreadInit(void)
{
    size_t stacksize;

    fthd_tbl = NULL;
    fth_tbl_dim = 0;
    fthd_num = 0;
    
    /* base flows tbl */
    if (FthreadTblExtend() == -1) {
        LogPrintf(LV_ERROR, "Unable to inizialie thread table");
        return -1;
    }
    /* initialized with default attributes */
    pthread_attr_init(&fthd_attr);
    pthread_mutex_init(&fthd_mux, NULL);
    pthread_mutex_init(&fthd_sync_mux, NULL);

    /* setting the size of the stack */
    stacksize = FTHD_STACK_SIZE;
    if (pthread_attr_setstacksize(&fthd_attr, stacksize) != 0) {
        LogPrintf(LV_FATAL, "Unable to set thread stack size");
        exit(-1);
    }

    return 0;
}


int FthreadCreate(int flow_id, start_routine fun, void *arg)
{
    pthread_t pid;
    int ret, i;

    pthread_mutex_lock(&fthd_mux);

    /* search free position */
    for (i=0; i<fth_tbl_dim; i++) {
        if (fthd_tbl[i].pid == 0) {
            break;
        }
    }
    if (i == fth_tbl_dim) {
        if (FthreadTblExtend() == -1) {
            LogPrintf(LV_ERROR, "Unable to extend thread data table");
            pthread_mutex_unlock(&fthd_mux);

            return -1;
        }
    }

    /* launch thread */
    pthread_mutex_lock(&fthd_sync_mux);
    ret = pthread_create(&pid, &fthd_attr, fun, arg);

    if (ret == 0) {
        pthread_detach(pid);
        fthd_tbl[i].fid = flow_id;
        fthd_tbl[i].pid = pid;
        fthd_num++;
        pthread_mutex_unlock(&fthd_mux);
        FlowSetElab(flow_id, i);
    }
    else {
        ret = -1;
        pthread_mutex_unlock(&fthd_mux);
    }
    /* syncronization both FthreadSync that Flow sync */
#if 0
    pthread_mutex_unlock(&fthd_sync_mux);
#else
    /* if the flow is in packet syncronization then we wait the first packet read */
    FlowCreateSync(flow_id, &fthd_sync_mux);
#endif

    return ret;
}


void FthreadSync(void)
{
    pthread_mutex_lock(&fthd_sync_mux);

    /* only to sincronize to FthreadCreate */

    pthread_mutex_unlock(&fthd_sync_mux);
}


void FthreadStackBase(int fthd_id, const void *base)
{
#ifdef XPL_CHECK_CODE
    pthread_mutex_lock(&fthd_mux);
    
    fthd_tbl[fthd_id].stack = base;

    pthread_mutex_unlock(&fthd_mux);
#endif
}


void* FthreadStack(int fthd_id)
{
    if (fthd_id == -1)
        return NULL;
    
    return fthd_tbl[fthd_id].stack;
}


void FthreadEnd(void)
{
    pthread_t pid;
    int i;

    pid = pthread_self();

    pthread_mutex_lock(&fthd_mux);

    /* search  thread position */
    for (i=0; i<fth_tbl_dim; i++) {
        if (pthread_equal(fthd_tbl[i].pid, pid) != 0) {
            break;
        }
    }

#ifdef XPL_CHECK_CODE
    if (i == fth_tbl_dim) {
        LogPrintf(LV_OOPS, "Thread not in the table (%s)", __FUNCTION__);
        exit(-1);
    }
#endif

    /* check presence of not deleted flow */
    while (fthd_tbl[i].fid != -1) {
        LogPrintf(LV_ERROR, "Flow %s is not deleted", FlowName(fthd_tbl[i].fid));
        pthread_mutex_unlock(&fthd_mux);
        FlowDettach(fthd_tbl[i].fid);
        pthread_mutex_lock(&fthd_mux);
    }
    FthreadElemInit(&fthd_tbl[i]);
    fthd_num--;

    pthread_mutex_unlock(&fthd_mux);
}


int FthreadChFlow(int fthd_id, int flow_id)
{
    pthread_mutex_lock(&fthd_mux);

#ifdef XPL_CHECK_CODE
    if (fthd_tbl[fthd_id].pid == 0) {
        pthread_mutex_unlock(&fthd_mux);
        LogPrintf(LV_OOPS, "Change flow at thread that not exist (%s)", __FUNCTION__);
        exit(-1);
        return -1;
    }
#endif
    fthd_tbl[fthd_id].fid = flow_id;

    pthread_mutex_unlock(&fthd_mux);

    return 0;
}


int  FthreadFlow(int fthd_id)
{
    int id;

    pthread_mutex_lock(&fthd_mux);

    id = fthd_tbl[fthd_id].fid;
    
    pthread_mutex_unlock(&fthd_mux);

    return id;
}


int  FthreadFlowId(pthread_t pid)
{
    int id, i;

    pthread_mutex_lock(&fthd_mux);
    
    /* search  thread position */
    for (i=0; i<fth_tbl_dim; i++) {
        if (pthread_equal(fthd_tbl[i].pid, pid) != 0) {
            break;
        }
    }
    if (i == fth_tbl_dim)
        id = -1;
    else
        id = fthd_tbl[i].fid;
    
    pthread_mutex_unlock(&fthd_mux);

    return id;
}


int FthreadId(pthread_t pid)
{
    int id, i;

    pthread_mutex_lock(&fthd_mux);
    
    /* search  thread position */
    for (i=0; i<fth_tbl_dim; i++) {
        if (pthread_equal(fthd_tbl[i].pid, pid) != 0) {
            break;
        }
    }
    if (i == fth_tbl_dim)
        id = -1;
    else
        id = i;
    
    pthread_mutex_unlock(&fthd_mux);

    return id;
}


unsigned long FthreadRunning(void)
{
    return fthd_num;
}


unsigned long FthreadTblDim(void)
{
    return fth_tbl_dim;
}
