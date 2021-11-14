/*-------------------------------------------------------------------------------
 * EDACS-LCN 
 * A program for decoding edacs/edacs extended addressing with esk
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
 * 2021-11 Version 1.0 EDACS-FM Florida Man Edition
 *-----------------------------------------------------------------------------*/
//#define _DEFAULT_SOURCE  //_BSD_SOURCE
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
#include <ncurses.h>
//#include <locale.h>

#define	SAMP_NUM		1000*3*2
#define	DOTTING			0xAAAAAA		//C71C71
#define	D_MASK			0xFFFFFF

unsigned char samples[SAMP_NUM];				//8-bit samples from rtl_fm (or rtl_udp)
signed short int raw_stream[SAMP_NUM/2];		//16-bit signed int samples

signed int AFC=0;								//Auto Frequency Control -> DC offset
signed int min=SHRT_MAX, max=SHRT_MIN;			//min and max sample values
unsigned int avg_cnt=0;							//avg array index variable
signed short int avg_arr[SAMP_NUM/2/3];

unsigned long long sr=0;						//shift register for pushing decoded binary data

char * ENT_list[13] = {
"███████╗██████╗  █████╗  ██████╗███████╗  ",
"██╔════╝██╔══██╗██╔══██╗██╔════╝██╔════╝  ",
"█████╗  ██║  ██║███████║██║     ███████╗  ",
"██╔══╝  ██║  ██║██╔══██║██║     ╚════██║  ",
"███████╗██████╔╝██║  ██║╚██████╗███████║  ",
"╚══════╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚══════╝  ",
"LCN CHANNEL   ██╗      ██████╗███╗   ██╗",
"              ██║     ██╔════╝████╗  ██║",
"              ██║     ██║     ██╔██╗ ██║",
"              ██║     ██║     ██║╚██╗██║",
"              ███████╗╚██████╗██║ ╚████║",
"              ╚══════╝ ╚═════╝╚═╝  ╚═══╝",
"",
};
//--------------------------------------------

int main(void)
{
    //setlocale(LC_ALL, "");
	signed int avg=0;		//sample average
	//FILE *fp; int fread;
	//AFC=getAFC(SAMP_NUM);
	for(short int i=0; i<13; i++)
	    {
            printf("%s \n", ENT_list[i]);
	    } 
	for(int i=0; i<SAMP_NUM/2/3-1; i++)	//zero array
	{
		avg_arr[i]=0;
	}
	
	while(1)
	{		
        //initscr(); //Initialize NCURSES screen window
        //noecho(); 
        //cbreak();
        //erase();
        /*for(short int i=0; i<11; i++)
	    {
            printw("%s \n", ENT_list[i]);
	    } */
        //refresh();
        
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
		//if(AFC!=0)printf("AFC=%d\n",AFC);
		}
		//--------------------------------------
		//printw("LEDACS-LCN\n");
		//printw("                        AFC=[%d]Hz\n", AFC);
		
        //refresh();
		sr=sr<<1;

		if (avg<AFC)
			sr|=1;
        
        //refresh();

	}
    //endwin();
	return 0;
}