function snr_perf(snr_min, snr_max, snr_step, iterations, csv_dir)
    %str_len = [84, 127, 169];
    str_len = [127];
    mappings = [2, 4, 8, 16];
    snr_range = snr_min:snr_step:snr_max;
    for len = str_len
        for map = mappings
            for j=1:length(snr_range)
                csv_name = strcat(csv_dir, 'results_', string(map), '_', string(len), '_', string(snr_range(j)), '_', ".csv");
                for k=1:iterations
                    command = strcat('./encode', " ", random_string(len),' SEEMOO 0 1500 8000 16 0', " ", string(map), ' 8 out.wav');
                    disp(command);
                    [status,cmdout] = system(command);
                    awgn_fm("out.wav", "output.wav", snr_range(j));
                    command = strcat('./decode output.wav 0', " ", string(map), ' 8  | grep "Bit flips"');
                    disp(command);
                    [status,cmdout] = system(command);
                    parts = split(cmdout, ' ');
                    if cmdout == ""
                        command = strcat("echo>> ", csv_name);
                        [status,cmdout] = system(command);
                    else
                        flips = num2str(string(parts(3)));
                        command = strcat("echo ", flips, " >> ", csv_name);
                        [status,cmdout] = system(command);
                    end
                end
            end  
        end
    end
    
    