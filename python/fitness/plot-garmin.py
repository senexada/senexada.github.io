#!/usr/bin/env python3

import csv
import sys
import plotext as plt

debug = "--debug" in sys.argv

if len(sys.argv) < 2:
    print("Usage: python3 plot_efficiency.py <file.csv> [--debug]")
    sys.exit(1)

file_path = sys.argv[1]

ratios = []
x = []

with open(file_path, newline="") as f:
    reader = csv.DictReader(f)
    rows = list(reader)
    rows.sort(key=lambda r: r.get("Date", ""))

    i = 0
    for row in rows:
        try:
            if "Running" not in row.get("Activity Type", ""):
                continue
            if "Treadmill" in row.get("Activity Type", ""):
                continue   # treadmill in garmin ignores incline, thus fundamentally broken
            max_hr = float(row["Max HR"])
            avg_hr = float(row["Avg HR"])
            avg_power = float(row["Avg Power"])

            if max_hr <= 142 and avg_hr > 0:
                if debug:
                   print(row)
                else:
                   ratios.append(avg_power / avg_hr)
                   x.append(i)
                   i += 1

        except (ValueError, KeyError):
            continue

if not ratios and not debug:
    print("No data matched the filter (Max HR <= 142).")
    sys.exit(1)

if debug:
    sys.exit(0)

plt.plot(x, ratios)
plt.ylim(0, 1.1*max(ratios))
plt.title("Power / HR Efficiency (Max HR ≤ 142)")
plt.xlabel("Filtered Runs")
plt.ylabel("Avg Power / Avg HR")
plt.show()
