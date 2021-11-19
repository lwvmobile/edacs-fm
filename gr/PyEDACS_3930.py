import EDACS_Radio_Combined_no_GUI_3930
import socket
import sys
import time

localIP     = "127.0.0.1"
localPort   = 6021
bufferSize  = 1024
ENT_list = [
"██████╗ ██╗   ██╗",                       
"██╔══██╗╚██╗ ██╔╝",                      
"██████╔╝ ╚████╔╝ ",                      
"██╔═══╝   ╚██╔╝  ",                       
"██║        ██║   ",                       
"╚═╝        ╚═╝PyEDACS Control Deck FME  ",                      
"███████╗██████╗  █████╗  ██████╗███████╗",
"██╔════╝██╔══██╗██╔══██╗██╔════╝██╔════╝",
"█████╗  ██║  ██║███████║██║     ███████╗",
"██╔══╝  ██║  ██║██╔══██║██║     ╚════██║",
"███████╗██████╔╝██║  ██║╚██████╗███████║",
"╚══════╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚══════╝",
"                                        "]
# Create a datagram socket
UDPServerSocket = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)
# Bind to address and ip
UDPServerSocket.bind((localIP, localPort))
#print("UDP server up and listening for frequency and squelch")
#device1 = input("Please specify control channel device string: \n")
#print(device1)
#device2 = input("Please specify lcn channel device string: \n")
#print(device2)
tb = EDACS_Radio_Combined_no_GUI_3930.EDACS_Radio_Combined_no_GUI_3930()
#tb.set_device1(device1)
#tb.set_device2(device2)
tb.start()
def ENT():
    ENT_list.reverse()
    for x in range(13):
        print(ENT_list.pop())
def udp_listen():
    bytesAddressPair = UDPServerSocket.recvfrom(bufferSize)
    m0 = bytesAddressPair[0]
    #print(bytesAddressPair)
    #print(m0)
    if m0[0] == 0:
        bv = m0[1:5] 
        newfreq = int.from_bytes(bv, "little")
        print("LCN Freq: ", newfreq)
        tb.set_freqlcn(newfreq)
    if m0[0] == 9:
        bv = m0[1:5] 
        newfreqcc = int.from_bytes(bv, "little")
        print("CC Freq: ", newfreqcc)
        tb.set_freqcc(newfreqcc)
    if m0[0] == 3:
        bv = m0[1:5] 
        gain = int.from_bytes(bv, "little")
        print("RF Gain: ", gain)
        tb.set_rfgain(gain)
    if m0[0] == 7:
        bv = m0[1:5]
        oldppm = tb.get_ppmcc()
        ppmadjust = int.from_bytes(bv, "little")
        newppmcc = oldppm + ppmadjust
        print("CC PPM Adjustment: ", newppmcc)
        tb.set_ppmcc(newppmcc)
    if m0[0] == 0x2:
        bv = m0[1:5]
        squelch = int.from_bytes(bv, "little")
        #print("LCN Squelch: ", squelch)
        if squelch == 0: #unmute
            tb.set_sqlcn(-150)
            #print("LCN Squelch: -150 dB")
        if squelch == 5000: #mute
            tb.set_sqlcn(0)
            #print("LCN Squelch: 0 dB")
ENT()
while(True):
    udp_listen()
    #pass


