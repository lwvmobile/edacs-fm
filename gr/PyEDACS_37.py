import EDACS_Radio_Combined_no_GUI_37
import socket
import sys
import struct

localIP     = "127.0.0.1"
localPort   = 6020
bufferSize  = 1024
print("PyEDACS Control Deck FME for GNU Radio 3.7")
# Create a datagram socket
UDPServerSocket = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)
# Bind to address and ip
UDPServerSocket.bind((localIP, localPort))
print("UDP server up and listening for frequency and squelch")
tb = EDACS_Radio_Combined_no_GUI_37.EDACS_Radio_Combined_no_GUI_37()
tb.start()

def udp_listen():
    bytesAddressPair = UDPServerSocket.recvfrom(bufferSize)
    m0 = bytesAddressPair[0]
    bv2 = struct.unpack('<BBBBB', m0)
    if bv2[0] == 0:
        bv = bv2[1:5] 
        newfreq = bv2[1]+(bv2[2]<<8)+(bv2[3]<<16)+(bv2[4]<<24)
        print("LCN Freq: ", newfreq)
        tb.set_freqlcn(newfreq)
    if bv2[0] == 9:
        bv = bv2[1:5] 
        newfreqcc = bv2[1]+(bv2[2]<<8)+(bv2[3]<<16)+(bv2[4]<<24)
        print("CC Freq: ", newfreqcc)
        tb.set_freqcc(newfreqcc)
    if bv2[0] == 3:
        bv = bv2[1:5] 
        gain = bv2[1]+(bv2[2]<<8)+(bv2[3]<<16)+(bv2[4]<<24)
        print("RF Gain: ", gain)
        tb.set_rfgain(gain)    
    
    if bv2[0] == 7:
        bv = bv2[1:5]
        oldppm = tb.get_ppmcc()
        newppmcc = oldppm + ppmadjust
        print("CC PPM Adjustment: ", newppmcc)
        #tb.set_ppmcc(newppmcc)
    if bv2[0] == 2:
        bv = bv2[1:5]
        squelch = bv2[1]+(bv2[2]<<8)+(bv2[3]<<16)+(bv2[4]<<24)
        print("LCN Squelch: ", squelch)
        if squelch == 0: #unmute
            tb.set_sqlcn(-150)
        if squelch == 5000: #mute
            tb.set_sqlcn(0)

while(True):
    udp_listen()
    

