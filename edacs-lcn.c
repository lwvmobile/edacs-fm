/*-------------------------------------------------------------------------------
 * EDACS-LCN 
 * A program for decoding edacs dotting sequence detection
 * 
 * ASCII art generated by:
 * https://fsymbols.com/generators/carty/
 * 
 * Jail Ascii Art by:
 * https://ascii.co.uk/art/jail
 * 
 * Portions of this software originally from: 
 * https://github.com/sp5wwp/ledacs     
 * XTAL Labs
 * 30 IV 2016
 * Many thanks to SP5WWP for permission to use and modify this software
 * 
 * LWVMOBILE  
 * 2021-12 Version EDACS-LCN Florida Man Edition
 *-----------------------------------------------------------------------------*/

#define _GNU_SOURCE
#include <stdio.h>
#include <unistd.h>
#include <limits.h>
#include <string.h>
#include <stdlib.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <fcntl.h>
#include <errno.h>

#define UDP_BUFLEN		5				//maximum UDP buffer length
#define SRV_IP 			"127.0.0.1"		//IP
#define UDP_PORT 		6020			//UDP port
#define SAMP_NUM		    1000*3*2

unsigned char samples[SAMP_NUM];				//8-bit samples from rtl_fm (or rtl_udp)
signed short int raw_stream[SAMP_NUM/2];		//16-bit signed int samples

signed int AFC=0;								//Auto Frequency Control -> DC offset
signed int min=SHRT_MAX, max=SHRT_MIN;			//min and max sample values
unsigned int avg_cnt=0;							//avg array index variable
signed short int avg_arr[SAMP_NUM/2/3];

unsigned long long sr=0;						//shift register for pushing decoded binary data

int handle;						//for UDP
unsigned short port = UDP_PORT;	//
char data[UDP_BUFLEN]={0};		//
struct sockaddr_in address;		//

char * FM_banner[13] = {
"███████╗██████╗  █████╗  ██████╗███████╗  ",
"██╔════╝██╔══██╗██╔══██╗██╔════╝██╔════╝  ",
"█████╗  ██║  ██║███████║██║     ███████╗  ",
"██╔══╝  ██║  ██║██╔══██║██║     ╚════██║  ",
"███████╗██████╔╝██║  ██║╚██████╗███████║  ",
"╚══════╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚══════╝  ",
"LCN CHANNEL   ██╗      ██████╗███╗   ██╗",
" with         ██║     ██╔════╝████╗  ██║",
"  Dotting     ██║     ██║     ██╔██╗ ██║",
"   Sequence   ██║     ██║     ██║╚██╗██║",
"    Detection ███████╗╚██████╗██║ ╚████║",
"     FME      ╚══════╝ ╚═════╝╚═╝  ╚═══╝",
"",
};

//--------------------------------------------
int init_udp()		//UDP init
{
	handle = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);

	if (handle <= 0)
	{
			printf("Failed to create socket\n");
			return 1;
	}

	printf("Sockets successfully initialized\n");

	memset((char *) &address, 0, sizeof(address));
	
	address.sin_family = AF_INET;
	address.sin_addr.s_addr = inet_addr(SRV_IP); //address of host
	address.sin_port = htons(port);

	return 0;
}

//--------------------------------
void squelchSet(unsigned long long int sq)		//squelch
{
	data[0]=2;
	data[1]=sq&0xFF;
	data[2]=(sq>>8)&0xFF;
	data[3]=(sq>>16)&0xFF;
	data[4]=(sq>>24)&0xFF;
	
	sendto(handle, data, UDP_BUFLEN, 0, (const struct sockaddr*) &address, sizeof(struct sockaddr_in));
}

int main(void)
{

	signed int avg=0;		//sample average
	init_udp();
	sleep(2);
	for(short int i=0; i<12; i++)
	{
    printf("%s \n", FM_banner[i]);
	}
	for(int i=0; i<SAMP_NUM/2/3-1; i++)	//zero array
	{
		avg_arr[i]=0;
	}
	while(1)
	{	
		read(0, samples, 3*2);		//read samples
		raw_stream[0]=(signed short int)((samples[0+1]<<8)|(samples[0]&0xFF));
		raw_stream[1]=(signed short int)((samples[2+1]<<8)|(samples[2]&0xFF));
		raw_stream[2]=(signed short int)((samples[4+1]<<8)|(samples[4]&0xFF));
		avg=(raw_stream[0]+raw_stream[1]+raw_stream[2])/3;
		
		//AFC recomputing using averaged samples
		avg_arr[avg_cnt]=avg;
		avg_cnt++;
		if (avg_cnt>=SAMP_NUM/2/3-1)	//reset after filling avg_array
		{
			avg_cnt=0;
			min=SHRT_MAX;
			max=SHRT_MIN;
		
			for(int i=0; i<SAMP_NUM/2/3-1; i++)	//simple min/max detector
			{
				if (avg_arr[i]>max)
					max=avg_arr[i];
				if (avg_arr[i]<min)
					min=avg_arr[i];
			}
		AFC=(min+max)/2;
		}
		//--------------------------------------
		
		sr=sr<<1;
		if (avg<AFC)
			sr|=1;
	
		if ( (sr&0xFFFFFFFFFFFFFFFF)==0xAAAAAAAAAAAAAAAA ) //dotting sequence
		{
			squelchSet(5000);
			sr = 0; //zero out sr so it doesn't keep tripping over itself
			raw_stream[0] = 0; //zero out everything else too
			raw_stream[1] = 0;
			raw_stream[2] = 0;
			//usleep(5*1000); //wait so it doesn't keep squelching, disabling due to delay causing new voice grant to hang up immediately.
		}

		else /*  */
		{
			
                    
		}
	}
	return 0;
}
