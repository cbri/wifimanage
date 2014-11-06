/* tcp_garbage.h
 * Dissector to group together packet of tcp flow that haven't a specific dissector
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

#include <sys/types.h>
#include <regex.h>

#ifndef __TCP_GARBAGE_H__
#define __TCP_GARBAGE_H__

/* threshold limit */
#define TCP_GRB_PERCENTAGE              80

/* path & buffer size */
#define TCP_GRB_THRESHOLD               (10*1024)
#define TCP_GRB_FILENAME_PATH_SIZE      512

/* packets limit for dependency */
#define TCP_GRB_PKT_LIMIT               50

/* l7 protocols dir, size, ... */
#define TCP_GRB_L7_PROT_DEFAULT         "./l7-patterns/"
#define TCP_GRB_L7_PROT_INSTALL         "/opt/xplico/bin/l7-patterns/"
#define TCP_GRB_L7_EXTENSION            ".pat"
#define TCP_GRB_L7_SIZE_LIM             (1024)


typedef struct _l7prot_t l7prot;
struct _l7prot_t {
    char *name;    /* protocol name */
    regex_t regex; /* protocol regular expressions */
    unsigned short prio; /* priority: auto tuning */
    l7prot *next;  /* next protocol pattern */
};


#endif /* __TCP_GARBAGE_H__ */
