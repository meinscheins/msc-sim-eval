function sfo_perf_acoustic_ax25(sfo_min, sfo_max, sfo_step, snr, iterations, csv_dir)
    sfo_range = sfo_min:sfo_step:sfo_max;
    bit_rates = ["300", "1200", "2400"];
    types = ["AX", "FX"];
    for rate = bit_rates
        for type = types
            for sfo = sfo_range
                csv_name = strcat(csv_dir, 'results_', string(rate), '_', string(type), '_', string(sfo), '_', ".csv");
                for k=1:iterations
                    if rate == "2400"
                        command = strcat('echo -n "TEST>TEST:', random_string(117), '"',"  | gen_packets -j -r 8000 -o out.wav -");
                        if type == "FX"
                            command = strcat('echo -n "TEST>TEST:', random_string(117), '"',"  | gen_packets -j -X 1 -r 8000 -o out.wav -");
                        end
                        [status,cmdout] = system(command);
                        sfo_acoustic("out.wav", "output.wav", sfo, snr);
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
                        sfo_acoustic("out.wav", "output.wav", sfo, snr);
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
    
    