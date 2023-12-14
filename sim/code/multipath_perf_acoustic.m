function multipath_perf_acoustic(delay_min, delay_max, delay_step, attenuation, snr, iterations, csv_dir)
    str_len = [84, 127, 169];
    mappings = [2, 4, 8, 16];
    delay_range = delay_min:delay_step:delay_max;
    for len = str_len
        for map = mappings
            for delay = delay_range
                csv_name = strcat(csv_dir, 'results_', string(map), '_', string(len), '_', string(delay), '_', ".csv");
                for k=1:iterations
                    command = strcat('./encode', " ", random_string(len),' SEEMOO 0 1500 8000 16 0', " ", string(map), ' 8 out.wav');
                    disp(command);
                    [status,cmdout] = system(command);
                    multipath_acoustic("out.wav", "output.wav", delay, attenuation, snr);
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
    
    