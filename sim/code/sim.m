%snr_perf(-10, 30, 0.5, 100, "/home/michi/src/msc-michael-hermann/code/perf/perf-data/snr-perf-rf-new/");
%sfo_perf(-3000, 3000, 50, 45, 100, "/home/michi/src/msc-michael-hermann/code/perf/perf-data/sfo-perf-rf/");
%cfo_perf(-3100, 3100, 50, 45, 100, "/home/michi/src/msc-michael-hermann/code/perf/perf-data/cfo-perf-rf/");
%snr_perf_acoustic(-10, 30, 0.5, 100, "/home/michi/src/msc-michael-hermann/code/perf/perf-data/snr-perf-acoustic-new/");
%sfo_perf_acoustic(-3000, 3000, 50, 45, 100, "/home/michi/src/msc-michael-hermann/code/perf/perf-data/sfo-perf-acoustic/");
%cfo_perf_acoustic(-1500, 1500, 50, 45, 100, "/home/michi/src/msc-michael-hermann/code/perf/perf-data/cfo-perf-acoustic/");
%multipath_perf_fm(0, 100, 1, 0.5, 45, 100, "/home/michi/src/msc-michael-hermann/code/perf/perf-data/multipath-perf-rf/");
%multipath_perf_acoustic(0, 100, 1, 0.5, 45, 100, "/home/michi/src/msc-michael-hermann/code/perf/perf-data/multipath-perf-acoustic/");

%snr_perf_ax25(-10, 30, 0.5, 100, "/home/michi/src/msc-michael-hermann/code/perf/perf-data-ax25/snr-perf-rf-new/");
%sfo_perf_ax25(-5000, 5000, 50, 45, 100, "/home/michi/src/msc-michael-hermann/code/perf/perf-data-ax25/sfo-perf-rf/");
%cfo_perf_ax25(-5000, 5000, 50, 45, 100, "/home/michi/src/msc-michael-hermann/code/perf/perf-data-ax25/cfo-perf-rf/");
%snr_perf_acoustic_ax25(-10, 30, 0.5, 100, "/home/michi/src/msc-michael-hermann/code/perf/perf-data-ax25/snr-perf-acoustic-new/");
%sfo_perf_acoustic_ax25(-5000, 5000, 50, 45, 100, "/home/michi/src/msc-michael-hermann/code/perf/perf-data-ax25/sfo-perf-acoustic/");
%cfo_perf_acoustic_ax25(-5000, 5000, 50, 45, 100, "/home/michi/src/msc-michael-hermann/code/perf/perf-data-ax25/cfo-perf-acoustic/");
%multipath_perf_fm_ax25(0, 100, 1, 0.5, 45, 100, "/home/michi/src/msc-michael-hermann/code/perf/perf-data-ax25/multipath-perf-rf/");
%multipath_perf_acoustic_ax25(0, 100, 1, 0.5, 45, 100, "/home/michi/src/msc-michael-hermann/code/perf/perf-data-ax25/multipath-perf-acoustic/");
%multipath_perf_acoustic(39, 39, 1, 0.5, 45, 1, "/home/michi/temp/");

%delays       = [0,  3.5,  5.5,   7,     9,   12,   14,   25,   30,   35,   36,   41,   46,   53];
%attenuations = [1, 0.42, 0.26, 0.24, 0.24, 0.11, 0.07, 0.08, 0.06, 0.05, 0.06, 0.04, 0.03, 0.03];
%multipath_acoustic('/home/michi/temp/funktest2copy/reson7_icom/2023-12-07_15.16.15.wav', '/home/michi/temp/funktest2copy/icom_delayed/2023-12-07_15.16.15.wav', delays, attenuations, 0)
