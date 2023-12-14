import numpy as np
import itertools
import matplotlib.pyplot as plt

plt.style.use('style.mplrc')
sfo_range = range(-3000, 3000+1, 50)
iterations = 100
mappings = [2, 4, 8]
message_length = ['127']
error_curve = np.zeros((len(mappings), len(sfo_range)))

for x in itertools.product(mappings, message_length, sfo_range):
    filename = "".join("perf-data/sfo-perf-rf/results_{0}_{1}_{2}_.csv".format(*x))
    with open(filename) as file:
        errors = 0
        for line in file:
            if line in ['\n', '\r\n']:
                errors += 1
            if "-1" in line:
                errors += 1
        error_curve[mappings.index(x[0]), sfo_range.index(x[2])] = errors/iterations

bit_rate = [1200]
protocol = ['AX']
sfo_range_2 = range(-5000, 5000+1, 50)
error_curve_2 = np.zeros((1, len(sfo_range_2)))
for x in itertools.product(bit_rate, protocol, sfo_range_2):
    filename = "".join("perf-data-ax25/sfo-perf-rf/results_{0}_{1}_{2}_.csv".format(*x))
    with open(filename) as file:
        errors = 0;
        for line in file:
            if "0" in line:
                errors += 1
        error_curve_2[0, sfo_range_2.index(x[2])] = errors/iterations

mapping_str = ["BPSK", "QPSK", "8PSK", "AX.25"]
colors = ["b", "g", "r", "c", "m", "y"]

x = np.arange(-5000, 5000+1, 50)
y = np.full((201, 1), 1)

for j in range(0, len(mappings)):
    error_plot = error_curve[j, :]
    y[40:161,0] = error_plot
    plt.plot(x, 1 - y, color = colors[j], label= mapping_str[j])
plt.plot(x, 1 - error_curve_2[0, :], color = colors[len(mappings)], label= mapping_str[len(mappings)])
plt.xlabel("SFO in ppm")
plt.ylabel("Packet Reception Rate")
plt.title("Acoustic SFO error rates" )
plt.ylim(-0.05, 1.05)
plt.legend(loc='upper right')
plt.savefig('res/sfo_rf.pdf')
plt.show()


