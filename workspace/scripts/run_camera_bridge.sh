#!/bin/bash
# Проброс данных камеры (RGB и Depth) из Gazebo Garden в ROS 2

echo "Starting Gazebo to ROS 2 camera bridge..."
source /opt/ros/humble/setup.bash
source ~/workspace/ros2_ws/install/setup.bash

# Для Gazebo Garden обычно топики камеры публикуются в абсолютных путях, если они без слэша в SDF
# Если в списке `gz topic -l` они другие - поменяйте названия здесь.
# Формат: <GZ_TOPIC>@<ROS2_TYPE>[<GZ_TYPE>

ros2 run ros_gz_bridge parameter_bridge \
    /camera@sensor_msgs/msg/Image[gz.msgs.Image \
    /camera_info@sensor_msgs/msg/CameraInfo[gz.msgs.CameraInfo \
    /depth_camera@sensor_msgs/msg/Image[gz.msgs.Image \
    /depth_camera/points@sensor_msgs/msg/PointCloud2[gz.msgs.PointCloudPacked
