import numpy as np
import itertools
import matplotlib.pyplot as plt
from scipy.ndimage import gaussian_filter1d

plt.style.use('style.mplrc')
snr_min = -10
snr_max = 30
snr_step = 0.5
snr_steps = range(int(snr_min*10), int(snr_max*10+1), int(snr_step*10))
iterations = 100
mappings = [2, 4, 8]
message_length = ['127']
error_curve = np.zeros((len(mappings)+1, len(snr_steps)))

snr_range = []
for n in snr_steps:
    snr_range.append(round(n/10,1))

snr_read = []
for n in snr_range:
    if n % 1 == 0:
        snr_read.append(str(int(n)))
    else:
        snr_read.append(str(n))

for x in itertools.product(mappings, message_length, snr_read):
    filename = "".join("perf-data/snr-perf-acoustic-new/results_{0}_{1}_{2}_.csv".format(*x))
    with open(filename) as file:
        errors = 0;
        for line in file:
            if line in ['\n', '\r\n']:
                errors += 1
            if "-1" in line:
                errors += 1
        error_curve[mappings.index(x[0]), snr_read.index(x[2])] = errors/iterations

bit_rate = [1200]
protocol = ['AX']

for x in itertools.product(bit_rate, protocol, snr_read):
    filename = "".join("perf-data-ax25/snr-perf-acoustic-new/results_{0}_{1}_{2}_.csv".format(*x))
    with open(filename) as file:
        errors = 0;
        for line in file:
            if "0" in line:
                errors += 1
        error_curve[len(mappings), snr_read.index(x[2])] = errors/iterations

mapping_str = ["BPSK", "QPSK", "8PSK", "AX.25"]
colors = ["b", "g", "r", "c"]

for i in range(0, len(mappings)+1):
    curve = gaussian_filter1d(1 - error_curve[i, :], sigma=1.5)
    plt.plot(snr_range , curve, color = colors[i], label= str(mapping_str[i]))
plt.xlabel("SNR in dB")
plt.ylabel("Packet Reception Rate")
plt.title("Acoustic SNR Error Rates")
plt.ylim(-0.05, 1.05)
plt.legend(loc='upper right')
plt.savefig('res/snr_acoustic.pdf')
plt.show()