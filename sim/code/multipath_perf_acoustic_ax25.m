function multipath_perf_acoustic_ax25(delay_min, delay_max, delay_step, attenuation, snr, iterations, csv_dir)
    delay_range = delay_min:delay_step:delay_max;
    bit_rates = ["300", "1200", "2400"];
    types = ["AX", "FX"];
    for rate = bit_rates
        for type = types
            for delay = delay_range
                csv_name = strcat(csv_dir, 'results_', string(rate), '_', string(type), '_', string(delay), '_', ".csv");
                for k=1:iterations
                    if rate == "2400"
                        command = strcat('echo -n "TEST>TEST:', random_string(117), '"',"  | gen_packets -j -r 8000 -o out.wav -");
                        if type == "FX"
                            command = strcat('echo -n "TEST>TEST:', random_string(117), '"',"  | gen_packets -j -X 1 -r 8000 -o out.wav -");
                        end
                        [status,cmdout] = system(command);
                        multipath_acoustic("out.wav", "output.wav", delay, attenuation, snr);
                        command = "atest -j output.wav  | grep packets";
                        [status,cmdout] = system(command);
                        parts = split(cmdout, ' ');
                        decode = num2str(string(parts(1)));
                        command = strcat("echo ", decode, " >> ", csv_name);
                        [status,cmdout] = system(command);
                    else
                        command = strcat('echo -n "TEST>TEST:', random_string(117), '"',"  | gen_packets -B ", string(rate), " -r 8000 -o out.wav -");
                        if type == "FX"
                            command = strcat('echo -n "TEST>TEST:', random_string(117), '"',"  | gen_packets -B ", string(rate), " -X 1 -r 8000 -o out.wav -");
                        end
                        [status,cmdout] = system(command);
                        multipath_acoustic("out.wav", "output.wav", delay, attenuation, snr);
                        command = strcat("atest -B ", string(rate), " output.wav  | grep packets");
                        [status,cmdout] = system(command);
                        parts = split(cmdout, ' ');
                        decode = num2str(string(parts(1)));
                        command = strcat("echo ", decode, " >> ", csv_name);
                        [status,cmdout] = system(command);
                    end
                end
            end  
        end
    end