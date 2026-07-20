#!/bin/bash
echo "Запускаем генератор леса..."
python3 /home/developer/workspace/scripts/generate_forest.py

echo "Запускаем симуляцию (PX4 + Gazebo) с миром forest.sdf..."
cd /home/developer/PX4-Autopilot

# Добавляем кастомную папку worlds в ресурсы Gazebo
export GZ_SIM_RESOURCE_PATH=$GZ_SIM_RESOURCE_PATH:/home/developer/workspace/worlds

# Фиксы графики для Wayland/Docker
export DISPLAY=:0
export QT_X11_NO_MITSHM=1
export LIBGL_ALWAYS_SOFTWARE=1

# Устанавливаем целевой мир
export PX4_GZ_WORLD=forest

# Запускаем сборку и симуляцию
make px4_sitl gz_x500_depth
