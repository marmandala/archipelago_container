#!/bin/bash
# Fast launch — skips make entirely, runs the already-built binary
echo "Launching PX4 SITL + Gazebo Garden..."
cd /home/developer/PX4-Autopilot
HEADLESS=1 make px4_sitl gz_x500_depth
