import numpy as np
import itertools
import matplotlib.pyplot as plt

plt.style.use('style.mplrc')
cfo_range = range(-1500, 1500+1, 50)
iterations = 100
mappings = [2, 4, 8]
message_length = ['127']
error_curve = error_curve = np.zeros((len(mappings)+1, len(cfo_range)))

for x in itertools.product(mappings, message_length, cfo_range):
    filename = "".join("perf-data/cfo-perf-rf/results_{0}_{1}_{2}_.csv".format(*x))
    with open(filename) as file:
        errors = 0
        for line in file:
            if line in ['\n', '\r\n']:
                errors += 1
            if "-1" in line:
                errors += 1
        error_curve[mappings.index(x[0]), cfo_range.index(x[2])] = errors/iterations

bit_rate = [1200]
protocol = ['AX']

for x in itertools.product(bit_rate, protocol, cfo_range):
    filename = "".join("perf-data-ax25/cfo-perf-rf/results_{0}_{1}_{2}_.csv".format(*x))
    with open(filename) as file:
        errors = 0;
        for line in file:
            if "0" in line:
                errors += 1
        error_curve[len(mappings), cfo_range.index(x[2])] = errors/iterations

mapping_str = ["BPSK", "QPSK", "8PSK", "AX.25"]
colors = ["b", "g", "r", "c", "m", "y"]

for j in range(0, len(mappings)+1):
    error_plot = error_curve[j, :]
    plt.plot(cfo_range, 1 - error_plot, color = colors[j], label= mapping_str[j])
plt.xlabel("CFO in Hertz")
plt.ylabel("Packet Reception Rate")
plt.title("Acoustic CFO error rates" )
plt.ylim(-0.05, 1.05)
plt.legend(loc='upper right')
plt.savefig('res/cfo_rf.pdf')
plt.show()


