# Based on https://github.com/enp1s0/mk_graph/simple_single_graph_from_csv/mk_graph.py

import matplotlib.pyplot as plt
import pandas as pd

# Output
output_file_name = "curand-result.pdf"

# The list of `type` in the input csv file
rng_type = [
        'CURAND_RNG_PSEUDO_DEFAULT',
        'CURAND_RNG_PSEUDO_XORWOW',
        'CURAND_RNG_PSEUDO_MRG32K3A',
        'CURAND_RNG_PSEUDO_MTGP32',
        'CURAND_RNG_PSEUDO_MT19937',
        'CURAND_RNG_PSEUDO_PHILOX4_32_10',
        'CURAND_RNG_QUASI_DEFAULT',
        'CURAND_RNG_QUASI_SOBOL32',
        'CURAND_RNG_QUASI_SCRAMBLED_SOBOL32',
        ]

# Figure config
plt.figure(figsize=(8, 3))
plt.xlabel("Num data")
plt.ylabel("Throughput [GB/s]")
plt.xscale("log", base=2)
plt.grid()

# Load input data
df = pd.read_csv("data.csv", encoding="UTF-8")

for t in rng_type:
    # Filter the input data
    df_t = df.query("rng=='" + t + "'")

    # Plot
    plt.plot(df_t['n'], df_t['n'] / df_t['time'] * 1e-9 * 4, label=t, markersize=4, marker="*")

# Legend config
plt.legend(loc='upper center',
        bbox_to_anchor=(.5, 1.54),
        ncol=2)

# Save to file
plt.savefig(output_file_name, bbox_inches="tight")
