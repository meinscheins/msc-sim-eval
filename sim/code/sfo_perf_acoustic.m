function sfo_perf_acoustic(sfo_min, sfo_max, sfo_step, snr, iterations, csv_dir)
    str_len = [84, 127, 169];
    mappings = [2, 4, 8, 16];
    sfo_range = sfo_min:sfo_step:sfo_max;
    for len = str_len
        for map = mappings
            for sfo =sfo_range
                csv_name = strcat(csv_dir, 'results_', string(map), '_', string(len), '_', string(sfo), '_', ".csv");
                for k=1:iterations
                    command = strcat('./encode', " ", random_string(len),' SEEMOO 0 1500 8000 16 0', " ", string(map), ' 8 out.wav');
                    disp(command);
                    [status,cmdout] = system(command);
                    sfo_acoustic("out.wav", "output.wav", sfo, snr);
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
    
    