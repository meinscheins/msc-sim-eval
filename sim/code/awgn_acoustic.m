function awgn_acoustic(input, output, snr)
    [y, fs] = audioread(input);
    
    %Add AWGN to FM Signal;
    y = awgn(y, snr, 'measured');
    y = y/max(abs(y));
    audiowrite(output, y, fs, 'BitsPerSample', 16);
    




