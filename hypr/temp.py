#!/usr/bin/env python3
"""
Smooth sunset for hyprsunset – two‑stage transition:
- Day (06:00–18:00): 6500K constant
- Evening (18:00–22:00): 6500K → 3000K linear
- Night (22:00–06:00): 3000K constant
"""

import subprocess
import time
from datetime import datetime

# --- Configuration -------------------------------------------------
DAY_TEMP = 6500      # Cool daylight
NIGHT_TEMP = 3000    # Warm, sleep‑friendly
EVENING_START = 18.0 # 6:00 PM
EVENING_END   = 22.0 # 10:00 PM
MORNING_START = 6.0  # 6:00 AM
UPDATE_INTERVAL = 60 # seconds

def linear_interp(t, t0, t1, v0, v1):
    """Linear interpolation between (t0,v0) and (t1,v1) at time t."""
    if t1 - t0 == 0:
        return v0
    progress = (t - t0) / (t1 - t0)
    progress = max(0.0, min(1.0, progress))
    return int(v0 + (v1 - v0) * progress)

def get_temperature(current_hour):
    """Return target temperature based on time of day."""
    if MORNING_START <= current_hour < EVENING_START:
        # Daytime: constant DAY_TEMP
        return DAY_TEMP
    elif EVENING_START <= current_hour < EVENING_END:
        # Evening: linear warm-down from DAY_TEMP to NIGHT_TEMP
        return linear_interp(current_hour, EVENING_START, EVENING_END, DAY_TEMP, NIGHT_TEMP)
    else:
        # Night: constant NIGHT_TEMP
        return NIGHT_TEMP

# --- Main loop -----------------------------------------------------
while True:
    now = datetime.now()
    current_hour = now.hour + now.minute / 60.0

    target_temp = get_temperature(current_hour)

    try:
        subprocess.run(
            ["hyprctl", "hyprsunset", "temperature", str(target_temp)],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            check=True
        )
    except subprocess.CalledProcessError:
        # hyprsunset may not be ready yet
        time.sleep(5)
        continue

    time.sleep(UPDATE_INTERVAL)
