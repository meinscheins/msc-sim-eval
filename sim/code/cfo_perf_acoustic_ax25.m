function cfo_perf_acoustic_ax25(fo_min, fo_max, fo_step, snr, iterations, csv_dir)
    fo_range = fo_min:fo_step:fo_max;
    bit_rates = ["300", "1200", "2400"];
    types = ["AX", "FX"];
    for rate = bit_rates
        for type = types
            for fo = fo_range
                csv_name = strcat(csv_dir, 'results_', string(rate), '_', string(type), '_', string(fo), '_', ".csv");
                for k=1:iterations
                    if rate == "2400"
                        command = strcat('echo -n "TEST>TEST:', random_string(117), '"',"  | gen_packets -j -r 8000 -o out.wav -");
                        if type == "FX"
                            command = strcat('echo -n "TEST>TEST:', random_string(117), '"',"  | gen_packets -j -X 1 -r 8000 -o out.wav -");
                        end
                        [status,cmdout] = system(command);
                        cfo_acoustic("out.wav", "output.wav", fo, snr);
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
                        cfo_acoustic("out.wav", "output.wav", fo, snr);
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
    
    