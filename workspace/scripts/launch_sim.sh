#!/bin/bash
# Fast launch — skips make entirely, runs the already-built binary
echo "Launching PX4 SITL + Gazebo Garden..."
cd /home/developer/workspace/PX4-Autopilot
make px4_sitl gz_x500_depth
