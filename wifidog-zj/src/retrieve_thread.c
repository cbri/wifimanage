#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <string.h>
#include <stdarg.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <unistd.h>
#include <syslog.h>
#include <signal.h>
#include <errno.h>

#include "../config.h"
#include "safe.h"
#include "common.h"
#include "conf.h"
#include "debug.h"
#include "retrieve_thread.h"
#include "util.h"
#include "centralserver.h"
#include "firewall.h"
#include "cJSON.h"


/** @internal
 * This function does the actual request.
 */
void
retrieve(const t_serv	*auth_server)
{
        ssize_t			numbytes;
        size_t	        	totalbytes;
	int		sockfd, nfds, done;

	char			request[MAX_BUF];
	fd_set			readfds;
	struct timeval		timeout;
	FILE * fh;
		char  *str = NULL;

	sockfd = connect_server(1);
	if (sockfd == -1) {
		
		return;
		
	}

	/*
	 * Prep & send request
	 */
	snprintf(request, sizeof(request) - 1,
			"GET %staskrequest/?dev_id=%s HTTP/1.0\r\n"
			"User-Agent: WiFiDog %s\r\n"
			"Host: %s\r\n"
			"\r\n",
			auth_server->serv_path,
			config_get_config()->dev_id,
			VERSION,
			auth_server->serv_hostname);

	
	send(sockfd, request, strlen(request), 0);

	debug(LOG_DEBUG, "Reading response %s %s",auth_server->serv_path,auth_server->serv_hostname);
	
	numbytes = totalbytes = 0;
	done = 0;
	do {
		FD_ZERO(&readfds);
		FD_SET(sockfd, &readfds);
		timeout.tv_sec = 30; /* XXX magic... 30 second */
		timeout.tv_usec = 0;
		nfds = sockfd + 1;

		nfds = select(nfds, &readfds, NULL, NULL, &timeout);

		if (nfds > 0) {
			/** We don't have to use FD_ISSET() because there
			 *  was only one fd. */
			numbytes = read(sockfd, request + totalbytes, MAX_BUF - (totalbytes + 1));
			if (numbytes < 0) {
				debug(LOG_ERR, "An error occurred while reading from auth server: %s", strerror(errno));
				/* FIXME */
				close(sockfd);
				return;
			}
			else if (numbytes == 0) {
				done = 1;
			}
			else {
				totalbytes += numbytes;
				debug(LOG_DEBUG, "Read %d bytes, total now %d", numbytes, totalbytes);
			}
		}
		else if (nfds == 0) {
			debug(LOG_ERR, "Timed out reading data via select() from auth server");
			/* FIXME */
			close(sockfd);
			return;
		}
		else if (nfds < 0) {
			debug(LOG_ERR, "Error reading data via select() from auth server: %s", strerror(errno));
			/* FIXME */
			close(sockfd);
			return;
		}
	} while (!done);
	close(sockfd);

	debug(LOG_DEBUG, "Done reading reply, total %d bytes", totalbytes);

	request[totalbytes] = '\0';
	char *out;cJSON *json; 
	json=cJSON_Parse(request); 
	char *task_id=NULL;
	char *task_code=NULL;
	char *task_param=NULL;
	if (!json) {
	   debug(LOG_DEBUG, "Error before: [%s]",cJSON_GetErrorPtr());
	} 
	else {
          cJSON * jresult = cJSON_GetObjectItem(json,"result");
	  if(jresult){
	     if(!strcasecmp(jresult->valuestring, "OK")){
 		debug(LOG_DEBUG, "Error : [%s]",cJSON_GetObjectItem(json,"message")->valuestring);	              
	     }
	  }  
          cJSON * jtaskid = cJSON_GetObjectItem(json,"task_id");
	  if(jtaskid){
		task_id = safe_strdup(jtaskid->valuestring);
	  }  
          cJSON * jtaskcode = cJSON_GetObjectItem(json,"task_code");
	  if(jtaskcode){
		task_code = safe_strdup(jtaskcode->valuestring);
	  }  
          cJSON * jtaskparam = cJSON_GetObjectItem(json,"task_param");
	  if(jtaskid){
		task_param = safe_strdup(jtaskparam->valuestring);
	  }  
	  out=cJSON_Print(json); 
	  cJSON_Delete(json); 
	  debug(LOG_DEBUG, "json task before: [%s]",out);
	  free(out); 
	} 
	if(task_code){
	  char *cmd;
	  safe_asprintf(&cmd, "%s %s",
				task_code,
				task_param);
	  debug(LOG_DEBUG, "cmd %s", cmd);
	  execute(cmd, 0);
	  free(cmd);

	}
	if(task_id){free(task_id);}
	if(task_code){free(task_code);}
	if(task_param){free(task_param);}
	
	
	return;	
}




