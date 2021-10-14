from Bio import SeqIO
from collections import defaultdict
from scipy.stats import entropy
import numpy as np


record = SeqIO.read('/home/ethollem/projects/VR-Sanger/runs/2021-08-17_714047_129248_data/pFC8-EH-_pFC9_t7_primer_1__2021-08-19_D04.ab1', 'abi')

CHANNELS = ["DATA9", "DATA10", "DATA11", "DATA12"]




channel_data = []

for i, each_channel in enumerate(CHANNELS):
    channel_data.append([])
    measurements = record.annotations['abif_raw'][each_channel]
    channel_data[i] = measurements[5:][::10]


data = np.array(channel_data)

def norm(array):
    return array / np.sum(array)
import matplotlib.pyplot as plt

data1 = np.apply_along_axis(norm, 0, data)
data2= entropy(data, axis=0, base=2)
plt.plot(data2, linestyle = 'dotted')
plt.savefig('books_read.png')


    

