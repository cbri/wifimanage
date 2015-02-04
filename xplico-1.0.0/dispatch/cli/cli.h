/* cli.h
 *
 * $Id: $
 *
 * Xplico - Internet Traffic Decoder
 * By Gianluca Costa <g.costa@xplico.org>
 * Copyright 2009 Gianluca Costa & Andrea de Franceschi. Web: www.xplico.org
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


#ifndef __CLI_H__
#define __CLI_H__

#define XCLI_STR_DIM             1024
#define XCLI_BASE_DIR            "xdecode"
#define XCLI_FILE_PATHS          XCLI_BASE_DIR"/lastdata.txt"
#define XCLI_MALLOC_LIMIT        (10*1024*1024)

/* configuration file */
#define CFG_PAR_CLI_XDECODE      "DISPATCH_CLI_DECODE_DIR"


#endif /* __CLI_H__ */
