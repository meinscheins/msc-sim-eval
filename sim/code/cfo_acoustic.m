function cfo_acoustic(input, output, fo, snr)
    [y, fs] = audioread(input);
    %Add AWGN
    snr_adjusted = snr + db(2*6*256/fs, 'power');
    y = awgn(y, snr_adjusted, 'measured');
    %apply CFO to Signal
    y = hilbert(y);
    y = frequencyOffset(y, fs, fo);
    y = real(y);
    y = y/max(abs(y));
    audiowrite(output, y, fs, 'BitsPerSample', 16);
end