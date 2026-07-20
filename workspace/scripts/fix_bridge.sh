#!/bin/bash
# Скрипт для пересборки ros_gz_bridge под Gazebo Harmonic (8.x)

echo "1. Удаляем несовместимый мост из apt (он собран под старый Ignition Fortress)..."
sudo apt remove -y ros-humble-ros-gz*

echo "1.5. Устанавливаем недостающие заголовочные файлы для сборки под Harmonic..."
sudo apt update && sudo apt install -y libgz-transport13-dev libgz-msgs10-dev libgz-math7-dev

echo "2. Клонируем исходники ros_gz в наш workspace..."
cd /home/developer/workspace/ros2_ws/src
if [ ! -d "ros_gz" ]; then
    git clone https://github.com/gazebosim/ros_gz.git -b humble
fi

echo "3. Собираем мост под Gazebo Harmonic..."
cd /home/developer/workspace/ros2_ws
source /opt/ros/humble/setup.bash

export GZ_VERSION=harmonic

MAKEFLAGS="-j1" colcon build --executor sequential --packages-up-to ros_gz_bridge --cmake-args -DBUILD_TESTING=OFF

echo ""
echo "Готово! Теперь обновите окружение:"
echo "source ~/workspace/ros2_ws/install/setup.bash"
echo "И попробуйте запустить ./run_camera_bridge.sh заново!"
