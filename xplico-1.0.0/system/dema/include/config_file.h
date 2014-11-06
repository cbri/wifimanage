/* config_file.h
 *
 * $Id: $
 *
 * Xplico System
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


#ifndef __CONFIG_FILE_H__
#define __CONFIG_FILE_H__

/* cfg line */
#define CFG_LINE_COMMENT           '#'
#define CFG_LINE_MAX_SIZE          512

/* directory paths */
#define CFG_PAR_TMP_DIR_PATH       "TMP_DIR_PATH"

/* log dir and name template */
#define CFG_PAR_LOG_DIR_PATH       "LOG_DIR_PATH"
#define CFG_PAR_LOG_NAME_TMP       "LOG_BASE_NAME"

/* DB params */
#define CFG_PAR_DB_TYPE            "DB_TYPE"
#define CFG_PAR_DB_FILE_NAME       "DB_FILENAME"

/* generic params */
#define CFG_PAR_LOG_LEVEL          "LOG_LEVEL"
#define CFG_PAR_PCAP_FILES_TIME    "TIME_BETWEEN_PCAPS"

#endif
