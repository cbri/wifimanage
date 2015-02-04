/* gearth.h
 * Create, from pei, the kml file to rappresent all connetcion with Google Earth
 *
 *
 * $Id: disp_aggreg.h,v 1.2 2007/11/07 14:30:41 costa Exp $
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

#ifndef __GEARTH_H__
#define __GEARTH_H__

#include "pei.h"

/* IMPORTANT: those functions can be used ONLY inside dispatcers */
int GearthNew(unsigned long id, const char *kml_path, const char *kml_tmp, const char *sem_name);
int GearthPei(unsigned long id, const pei *ppei);
int GearthClose(unsigned long id);

#endif /* __GEARTH_H__ */
