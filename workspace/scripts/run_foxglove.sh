#!/bin/bash
# Запуск Foxglove Bridge для подключения из Foxglove Studio
echo "Starting Foxglove Bridge on ws://localhost:8765..."
source /opt/ros/humble/setup.bash
source /home/developer/workspace/ros2_ws/install/setup.bash
ros2 run foxglove_bridge foxglove_bridge
