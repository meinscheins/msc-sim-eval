import numpy as np
import itertools
import matplotlib.pyplot as plt
from scipy.ndimage import gaussian_filter1d

plt.style.use('style.mplrc')
delay_range = range(0, 70+1, 1)
iterations = 100
mappings = [2, 4, 8]
message_length = ['127']
error_curve = error_curve = np.zeros((len(mappings) +1, len(delay_range)))

for x in itertools.product(mappings, message_length, delay_range):
    filename = "".join("perf-data/multipath-perf-acoustic/results_{0}_{1}_{2}_.csv".format(*x))
    with open(filename) as file:
        errors = 0
        for line in file:
            if line in ['\n', '\r\n']:
                errors += 1
            if "-1" in line:
                errors += 1
        error_curve[mappings.index(x[0]), delay_range.index(x[2])] = errors/iterations


bit_rate = [1200]
protocol = ['AX']

for x in itertools.product(bit_rate, protocol, delay_range):
    filename = "".join("perf-data-ax25/multipath-perf-acoustic/results_{0}_{1}_{2}_.csv".format(*x))
    with open(filename) as file:
        errors = 0;
        for line in file:
            if "0" in line:
                errors += 1
        error_curve[len(mappings), delay_range.index(x[2])] = errors/iterations

mapping_str = ["BPSK", "QPSK", "8PSK", "AX.25"]
colors = ["b", "g", "r", "c", "m", "y"]
mesg_save_str = ["s", "m", "l"]

#for j in range(0, len(mappings)+1):
#    curve = gaussian_filter1d(1 - error_curve[j, :], sigma=1.5)
#    plt.plot(delay_range, curve, color = colors[j], label= str(mapping_str[j]))
for j in range(0, len(mappings)):
    curve = gaussian_filter1d(1 - error_curve[j, :], sigma=1.5)
    plt.plot(delay_range, curve, color = colors[j], label= str(mapping_str[j]))
#curve = gaussian_filter1d(1 - error_curve[3, :], sigma=1)
curve = 1- error_curve[3, :]
plt.plot(delay_range, curve, color = colors[3], label= str(mapping_str[3]))
plt.xlabel("Path difference " + r'$T_{\Delta}$' +" in ms")
plt.ylabel("Packet Reception Rate")
plt.title("Acoustic Multipath Error Rates")
plt.ylim(-0.05, 1.05)
plt.legend(loc='upper left')
plt.savefig('res/multipath_acoustic.pdf')
plt.show()



