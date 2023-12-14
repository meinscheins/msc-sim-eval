function sfo_fm(input, output, sfo, snr)
    f_delta = 5e3;
    [y, fs] = audioread(input);
    fs_fm = 10*fs;

    %FM Modulator and and Demodulator
    fm_mod = comm.FMModulator( ...
        'SampleRate',fs_fm, ...
        'FrequencyDeviation',f_delta);
    fm_demod = comm.FMDemodulator(fm_mod);

    %Upsample signal and FM modulation
    y_re = resample(y, fs_fm, fs);
    s = fm_mod(y_re);

    %Add AWGN to FM Signal
    snr_adjusted = snr + db(2*10e3/fs_fm, 'power');
    s = awgn(s, snr_adjusted, 'measured');

    %apply SFO to FM Signal
    sro = comm.SampleRateOffset(sfo);
    s = sro(s);

    %Downsample signal and FM demodulation
    z_re = fm_demod(s);
    z = resample(z_re, fs, fs_fm);
    z = z/max(abs(z));
    audiowrite(output, z, fs, 'BitsPerSample', 16);
end