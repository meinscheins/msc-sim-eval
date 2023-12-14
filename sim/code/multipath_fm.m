function multipath_fm (input, output, delays, attenuations, snr)
    f_delta = 5e3;
    [y, fs] = audioread(input);
    fs_fm = 10*fs;
    %FM Modulator and and Demodulator
    fm_mod = comm.FMModulator( ...
        'SampleRate',fs_fm, ...
        'FrequencyDeviation',f_delta);
    fm_demod = comm.FMDemodulator(fm_mod);

    y_re = resample(y, fs_fm, fs);
    s = fm_mod(y_re);

    acc = s;
    for i = 1:length(delays)
        padding = zeros(fix(delays(i)/1000*fs_fm), 1);
        delay = [padding; s]; 
        acc = [acc; padding] + attenuations(i)*delay;
    end
    s = acc;
    y_re = fm_demod(s);
    y = resample(y_re, fs, fs_fm);
    %Add AWGN to FM Signal
    snr_adjusted = snr + db(2*10e3/fs_fm, 'power');
    y = awgn(y, snr_adjusted, 'measured');
    y = y/max(abs(y));
    audiowrite(output, y, fs, 'BitsPerSample', 16);
