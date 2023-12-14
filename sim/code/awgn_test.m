function awgn_test(input, snr)
    [y, fs] = audioread(input);
    %Add AWGN to FM Signal
    disp(rms(awgn(y, snr, 'measured')));
    disp(rms(awgn(y, snr, db(rms(y), 'power'))));
    




