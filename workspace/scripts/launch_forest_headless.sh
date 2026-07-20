#!/bin/bash
echo "Запускаем генератор леса (headless)..."
python3 /home/developer/workspace/scripts/generate_forest.py

echo "Запускаем headless симуляцию (PX4 + Gazebo) с миром forest.sdf..."
cd /home/developer/PX4-Autopilot

# Добавляем кастомную папку worlds в ресурсы Gazebo
export GZ_SIM_RESOURCE_PATH=$GZ_SIM_RESOURCE_PATH:/home/developer/workspace/worlds

# Устанавливаем целевой мир
export PX4_GZ_WORLD=forest

# Запускаем сборку и симуляцию без GUI
HEADLESS=1 make px4_sitl gz_x500_depth
