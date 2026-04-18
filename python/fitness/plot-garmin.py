#!/usr/bin/env python3

import csv
import sys
import plotext as plt

if len(sys.argv) != 2:
    print("Usage: python3 plot_efficiency.py <file.csv>")
    sys.exit(1)

file_path = sys.argv[1]

ratios = []
x = []

with open(file_path, newline="") as f:
    reader = csv.DictReader(f)

    i = 0
    for row in reader:
        try:
            max_hr = float(row["Max HR"])
            avg_hr = float(row["Avg HR"])
            avg_power = float(row["Avg Power"])

            if max_hr <= 142 and avg_hr > 0:
                ratios.append(avg_power / avg_hr)
                x.append(i)
                i += 1

        except (ValueError, KeyError):
            continue

if not ratios:
    print("No data matched the filter (Max HR <= 142).")
    sys.exit(1)

plt.plot(x, ratios)
plt.title("Power / HR Efficiency (Max HR ≤ 142)")
plt.xlabel("Filtered Runs")
plt.ylabel("Avg Power / Avg HR")
plt.show()
