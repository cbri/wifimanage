/* geoiploc.c
 *
 * $Id: $
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

#include "geoiploc.h"
#include "configs.h"
#include "log.h"

#if (XPL_GEO_IP && GEOIP_LIBRARY)
#include "GeoIP.h"
#include "GeoIPCity.h"

static GeoIP *gi;
static pthread_mutex_t atom; /* atomic action */

int GeoIPLocInit(void)
{
    /* try to open an db */
    gi = GeoIP_open("/opt/xplico/GeoLiteCity.dat", GEOIP_MEMORY_CACHE);
    if (gi == NULL) {
        gi = GeoIP_open("GeoLiteCity.dat", GEOIP_MEMORY_CACHE);
        if (gi == NULL) {
            gi = GeoIP_open("/opt/xplicopro/GeoLiteCity.dat", GEOIP_MEMORY_CACHE);
        }
    }
    if (gi == NULL) {
        LogPrintf(LV_ERROR, "GeoIP without GeoLiteCity database, see INSTALL");
        return -1;
    }
    pthread_mutex_init(&atom, NULL);

    return 0;
}


int GeoIPLocIP(ftval *ip, enum ftype itype, float *latitude, float *longitude)
{
    GeoIPRecord *gir;

    if (gi == NULL)
       return -1;

    gir = NULL;
    switch (itype) {
    case FT_IPv4:
        pthread_mutex_lock(&atom);
        gir = GeoIP_record_by_ipnum(gi, ntohl(ip->uint32));
        pthread_mutex_unlock(&atom);
        break;
        
    case FT_IPv6:
#warning "to do"
        break;

    default:
        LogPrintf(LV_ERROR, "GeoIP IP type error");
    }

    if (gir != NULL) {
        *latitude = gir->latitude;
        *longitude = gir->longitude;
        GeoIPRecord_delete(gir);
        return 0;
    }

    return -1;
}


int GeoIPLocAddr(char *addr, float *latitude, float *longitude)
{
    GeoIPRecord *gir;

    if (gi == NULL)
       return -1;

    gir = GeoIP_record_by_addr(gi, (const char *)addr);
    if (gir != NULL) {
        *latitude = gir->latitude;
        *longitude = gir->longitude;
        GeoIPRecord_delete(gir);
        return 0;
    }
    
    return -1;
}

#else /* GeoIPLoc diabled */

int GeoIPLocInit(void)
{
    return 0;
}


int GeoIPLocIP(ftval *ip, enum ftype itype, float *latitude, float *longitude)
{
    return -1;
}


int GeoIPLocAddr(char *addr, float *latitude, float *longitude)
{
    return -1;
}

#endif
