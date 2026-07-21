#!/bin/bash
# Запуск Foxglove Bridge для подключения из Foxglove Studio
echo "Starting Foxglove Bridge on ws://localhost:8765..."
ros2 run foxglove_bridge foxglove_bridge
