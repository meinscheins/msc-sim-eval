function multipath_acoustic (input, output, delays, attenuations, snr)
    [y, fs] = audioread(input);
    acc = y;
    for i = 1:length(delays)
        padding = zeros(fix(delays(i)/1000*fs), 1);
        padding2 = zeros(length(acc)-length(y), 1);
        delay = [padding; y; padding2]; 
        acc = [acc; padding] + attenuations(i)*delay;
    end
    y = acc;
    snr_adjusted = snr + db(2*6*256/fs, 'power');
    %y = awgn(y, snr_adjusted, 'measured');
    %y = y/max(abs(y));
    audiowrite(output, y, fs, 'BitsPerSample', 16);
