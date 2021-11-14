#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#
# SPDX-License-Identifier: GPL-3.0
#
# GNU Radio Python Flow Graph
# Title: EDACS Radio Combined no GUI 38
# Author: lwvmobile
# GNU Radio version: 3.8.1.0

from gnuradio import analog
from gnuradio import blocks
from gnuradio import filter
from gnuradio.filter import firdes
from gnuradio import gr
import sys
import signal
from argparse import ArgumentParser
from gnuradio.eng_arg import eng_float, intx
from gnuradio import eng_notation
import osmosdr
import time

class EDACS_Radio_Combined_no_GUI_38(gr.top_block):

    def __init__(self):
        gr.top_block.__init__(self, "EDACS Radio Combined no GUI 38")

        ##################################################
        # Variables
        ##################################################
        self.samp_rate = samp_rate = 2048000
        self.volume = volume = 3
        self.transition = transition = 1500
        self.sqlcn = sqlcn = -150
        self.rfgain = rfgain = 42
        self.quadrature = quadrature = int(samp_rate/4)
        self.ppmlcn = ppmlcn = 0
        self.ppmcc = ppmcc = 0
        self.freqlcn = freqlcn = 850000000
        self.freqcc = freqcc = 850000000
        self.cutoff = cutoff = 25000

        ##################################################
        # Blocks
        ##################################################
        self.rtlsdr_source_1 = osmosdr.source(
            args="numchan=" + str(1) + " " + 'rtl=1'
        )
        self.rtlsdr_source_1.set_time_unknown_pps(osmosdr.time_spec_t())
        self.rtlsdr_source_1.set_sample_rate(samp_rate)
        self.rtlsdr_source_1.set_center_freq(freqlcn, 0)
        self.rtlsdr_source_1.set_freq_corr(ppmlcn, 0)
        self.rtlsdr_source_1.set_gain(rfgain, 0)
        self.rtlsdr_source_1.set_if_gain(20, 0)
        self.rtlsdr_source_1.set_bb_gain(20, 0)
        self.rtlsdr_source_1.set_antenna('', 0)
        self.rtlsdr_source_1.set_bandwidth(0, 0)
        self.rtlsdr_source_0 = osmosdr.source(
            args="numchan=" + str(1) + " " + 'rtl=0'
        )
        self.rtlsdr_source_0.set_time_unknown_pps(osmosdr.time_spec_t())
        self.rtlsdr_source_0.set_sample_rate(samp_rate)
        self.rtlsdr_source_0.set_center_freq(freqcc, 0)
        self.rtlsdr_source_0.set_freq_corr(ppmcc, 0)
        self.rtlsdr_source_0.set_gain(rfgain, 0)
        self.rtlsdr_source_0.set_if_gain(20, 0)
        self.rtlsdr_source_0.set_bb_gain(20, 0)
        self.rtlsdr_source_0.set_antenna('', 0)
        self.rtlsdr_source_0.set_bandwidth(0, 0)
        self.rational_resampler_xxx_1_0 = filter.rational_resampler_fff(
                interpolation=48000,
                decimation=quadrature,
                taps=None,
                fractional_bw=None)
        self.rational_resampler_xxx_1 = filter.rational_resampler_fff(
                interpolation=48000,
                decimation=quadrature,
                taps=None,
                fractional_bw=None)
        self.rational_resampler_xxx_0_0 = filter.rational_resampler_ccc(
                interpolation=1,
                decimation=4,
                taps=None,
                fractional_bw=None)
        self.rational_resampler_xxx_0 = filter.rational_resampler_ccc(
                interpolation=1,
                decimation=4,
                taps=None,
                fractional_bw=None)
        self.low_pass_filter_0_0 = filter.fir_filter_ccf(
            1,
            firdes.low_pass(
                1,
                samp_rate,
                cutoff,
                transition,
                firdes.WIN_HAMMING,
                6.76))
        self.low_pass_filter_0 = filter.fir_filter_ccf(
            1,
            firdes.low_pass(
                1,
                samp_rate,
                cutoff,
                transition,
                firdes.WIN_HAMMING,
                6.76))
        self.blocks_udp_sink_0_0 = blocks.udp_sink(gr.sizeof_short*1, '127.0.0.1', 2001, 1472, False)
        self.blocks_udp_sink_0 = blocks.udp_sink(gr.sizeof_short*1, '127.0.0.1', 2000, 1472, False)
        self.blocks_float_to_short_0_0 = blocks.float_to_short(1, 500)
        self.blocks_float_to_short_0 = blocks.float_to_short(1, 500)
        self.blocks_endian_swap_0_0 = blocks.endian_swap(2)
        self.blocks_endian_swap_0 = blocks.endian_swap(2)
        self.analog_wfm_rcv_0_0 = analog.wfm_rcv(
        	quad_rate=quadrature,
        	audio_decimation=1,
        )
        self.analog_wfm_rcv_0 = analog.wfm_rcv(
        	quad_rate=quadrature,
        	audio_decimation=1,
        )
        self.analog_simple_squelch_cc_0 = analog.simple_squelch_cc(sqlcn, 1)



        ##################################################
        # Connections
        ##################################################
        self.connect((self.analog_simple_squelch_cc_0, 0), (self.analog_wfm_rcv_0_0, 0))
        self.connect((self.analog_wfm_rcv_0, 0), (self.rational_resampler_xxx_1, 0))
        self.connect((self.analog_wfm_rcv_0_0, 0), (self.rational_resampler_xxx_1_0, 0))
        self.connect((self.blocks_endian_swap_0, 0), (self.blocks_udp_sink_0, 0))
        self.connect((self.blocks_endian_swap_0_0, 0), (self.blocks_udp_sink_0_0, 0))
        self.connect((self.blocks_float_to_short_0, 0), (self.blocks_endian_swap_0, 0))
        self.connect((self.blocks_float_to_short_0_0, 0), (self.blocks_endian_swap_0_0, 0))
        self.connect((self.low_pass_filter_0, 0), (self.analog_wfm_rcv_0, 0))
        self.connect((self.low_pass_filter_0_0, 0), (self.analog_simple_squelch_cc_0, 0))
        self.connect((self.rational_resampler_xxx_0, 0), (self.low_pass_filter_0, 0))
        self.connect((self.rational_resampler_xxx_0_0, 0), (self.low_pass_filter_0_0, 0))
        self.connect((self.rational_resampler_xxx_1, 0), (self.blocks_float_to_short_0, 0))
        self.connect((self.rational_resampler_xxx_1_0, 0), (self.blocks_float_to_short_0_0, 0))
        self.connect((self.rtlsdr_source_0, 0), (self.rational_resampler_xxx_0, 0))
        self.connect((self.rtlsdr_source_1, 0), (self.rational_resampler_xxx_0_0, 0))

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.set_quadrature(int(self.samp_rate/4))
        self.low_pass_filter_0.set_taps(firdes.low_pass(1, self.samp_rate, self.cutoff, self.transition, firdes.WIN_HAMMING, 6.76))
        self.low_pass_filter_0_0.set_taps(firdes.low_pass(1, self.samp_rate, self.cutoff, self.transition, firdes.WIN_HAMMING, 6.76))
        self.rtlsdr_source_0.set_sample_rate(self.samp_rate)
        self.rtlsdr_source_1.set_sample_rate(self.samp_rate)

    def get_volume(self):
        return self.volume

    def set_volume(self, volume):
        self.volume = volume

    def get_transition(self):
        return self.transition

    def set_transition(self, transition):
        self.transition = transition
        self.low_pass_filter_0.set_taps(firdes.low_pass(1, self.samp_rate, self.cutoff, self.transition, firdes.WIN_HAMMING, 6.76))
        self.low_pass_filter_0_0.set_taps(firdes.low_pass(1, self.samp_rate, self.cutoff, self.transition, firdes.WIN_HAMMING, 6.76))

    def get_sqlcn(self):
        return self.sqlcn

    def set_sqlcn(self, sqlcn):
        self.sqlcn = sqlcn
        self.analog_simple_squelch_cc_0.set_threshold(self.sqlcn)

    def get_rfgain(self):
        return self.rfgain

    def set_rfgain(self, rfgain):
        self.rfgain = rfgain
        self.rtlsdr_source_0.set_gain(self.rfgain, 0)
        self.rtlsdr_source_1.set_gain(self.rfgain, 0)

    def get_quadrature(self):
        return self.quadrature

    def set_quadrature(self, quadrature):
        self.quadrature = quadrature

    def get_ppmlcn(self):
        return self.ppmlcn

    def set_ppmlcn(self, ppmlcn):
        self.ppmlcn = ppmlcn
        self.rtlsdr_source_1.set_freq_corr(self.ppmlcn, 0)

    def get_ppmcc(self):
        return self.ppmcc

    def set_ppmcc(self, ppmcc):
        self.ppmcc = ppmcc
        self.rtlsdr_source_0.set_freq_corr(self.ppmcc, 0)

    def get_freqlcn(self):
        return self.freqlcn

    def set_freqlcn(self, freqlcn):
        self.freqlcn = freqlcn
        self.rtlsdr_source_1.set_center_freq(self.freqlcn, 0)

    def get_freqcc(self):
        return self.freqcc

    def set_freqcc(self, freqcc):
        self.freqcc = freqcc
        self.rtlsdr_source_0.set_center_freq(self.freqcc, 0)

    def get_cutoff(self):
        return self.cutoff

    def set_cutoff(self, cutoff):
        self.cutoff = cutoff
        self.low_pass_filter_0.set_taps(firdes.low_pass(1, self.samp_rate, self.cutoff, self.transition, firdes.WIN_HAMMING, 6.76))
        self.low_pass_filter_0_0.set_taps(firdes.low_pass(1, self.samp_rate, self.cutoff, self.transition, firdes.WIN_HAMMING, 6.76))



def main(top_block_cls=EDACS_Radio_Combined_no_GUI_38, options=None):
    tb = top_block_cls()

    def sig_handler(sig=None, frame=None):
        tb.stop()
        tb.wait()
        sys.exit(0)

    signal.signal(signal.SIGINT, sig_handler)
    signal.signal(signal.SIGTERM, sig_handler)

    tb.start()
    try:
        input('Press Enter to quit: ')
    except EOFError:
        pass
    tb.stop()
    tb.wait()


if __name__ == '__main__':
    main()
