# Start with ROS2 Humble Desktop Full
FROM osrf/ros:humble-desktop-full

ARG USERNAME=developer
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Core development tools
RUN apt-get update && apt-get install -y \
    ca-certificates gnupg lsb-release sudo wget curl git vim build-essential cmake \
    python3-pip python-is-python3 gdb valgrind \
    && rm -rf /var/lib/apt/lists/*

# PX4 strict Python dependencies
RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir \
    empy==3.3.4 future pyros-genmsg kconfiglib jsonschema jinja2 pyserial pyyaml packaging toml numpy pandas

# Gazebo Garden
RUN wget https://packages.osrfoundation.org/gazebo.gpg -O /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null && \
    apt-get update && apt-get install -y gz-garden libgz-sim7-dev libgz-transport12-dev libgz-msgs9-dev libgz-math7-dev && rm -rf /var/lib/apt/lists/*

# PX4 dependencies
RUN apt-get update && apt-get install -y \
    astyle lcov libgstreamer-plugins-base1.0-dev gstreamer1.0-plugins-bad gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-libav ninja-build protobuf-compiler \
    libeigen3-dev libopencv-dev rsync libarmadillo-dev libnlopt-cxx-dev libpcl-dev \
    ros-humble-image-pipeline ros-humble-foxglove-bridge \
    && rm -rf /var/lib/apt/lists/*

# Micro-XRCE-DDS Agent
RUN cd /tmp && \
    git clone https://github.com/eProsima/Micro-XRCE-DDS-Agent.git && \
    cd Micro-XRCE-DDS-Agent && mkdir build && cd build && \
    cmake .. && make && make install && ldconfig /usr/local/lib/ && \
    cd / && rm -rf /tmp/Micro-XRCE-DDS-Agent

# Setup user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -s /bin/bash \
    && echo "$USERNAME:$USERNAME" | chpasswd \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME
WORKDIR /home/$USERNAME

# Clone and build PX4-Autopilot INSIDE the image
RUN git clone -b release/1.15 https://github.com/PX4/PX4-Autopilot.git --recursive && \
    cd PX4-Autopilot && \
    git checkout v1.15.4 && \
    git submodule update --init --recursive && \
    DONT_RUN=1 make px4_sitl gz_x500_depth

# Clone and build ROS2 workspace INSIDE the image
RUN mkdir -p ros2_ws/src && cd ros2_ws/src && \
    git clone -b release/1.15 https://github.com/PX4/px4_msgs.git && \
    git clone -b release/1.15 https://github.com/PX4/px4_ros_com.git && \
    git clone -b humble https://github.com/gazebosim/ros_gz.git && \
    cd /home/$USERNAME/ros2_ws && \
    bash -c "source /opt/ros/humble/setup.bash && export GZ_VERSION=garden && colcon build --symlink-install --cmake-args -DBUILD_TESTING=OFF"

# Configure bash environment
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc && \
    echo "source /home/$USERNAME/ros2_ws/install/setup.bash 2>/dev/null || true" >> ~/.bashrc && \
    echo "source /usr/share/gazebo/setup.bash 2>/dev/null || true" >> ~/.bashrc && \
    echo "export GZ_SIM_SYSTEM_PLUGIN_PATH=\$GZ_SIM_SYSTEM_PLUGIN_PATH:/home/$USERNAME/PX4-Autopilot/build/px4_sitl_default/build_gz-garden" >> ~/.bashrc

# Set default working directory to where user scripts will be mounted
WORKDIR /home/$USERNAME/workspace
