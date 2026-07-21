# Archipelago Container

This repository contains the simulation environment and development infrastructure for autonomous UAVs using PX4 Autopilot, ROS 2 Humble, and Gazebo Garden. The architecture is designed to decouple the heavy build processes from the local development workspace, utilizing Docker and a CI/CD pipeline.

## Architecture Overview

The system consists of two primary components:
1. **Container Image**: A monolithic Docker image built via GitHub Actions. It contains the base OS (Ubuntu 22.04), ROS 2 Humble Desktop, PX4-Autopilot (v1.15.4), Gazebo Garden, and all compiled C++ components, including `ros_gz_bridge` and `px4_msgs`.
2. **Workspace Directory**: The `workspace/` directory contains runtime scripts, Python-based world generators, and future flight logic nodes. This directory is mounted into the container at runtime, allowing rapid development without container rebuilds.

## Prerequisites

- Docker installed on the host machine.
- A Docker Hub account with an access token for pulling the private image.
- (Optional) Foxglove Studio installed locally for telemetry and video stream visualization.

## Setup and Usage

### 1. Pulling the Docker Image

The Docker image is built automatically by GitHub Actions and pushed to Docker Hub. To pull the latest version to your deployment server:

```bash
docker login
docker pull <YOUR_DOCKERHUB_USERNAME>/px4-sim:latest
```

### 2. Running the Container

Start the container using the host network and map the local workspace directory into the container environment. Execute this command from the root of the repository:

```bash
docker run -it --rm \
  --net=host \
  --privileged \
  -v $(pwd)/workspace:/home/developer/workspace \
  <YOUR_DOCKERHUB_USERNAME>/px4-sim:latest bash
```

### 3. Launching the Simulation

The simulation architecture requires launching several components. Inside the running container, open multiple terminal sessions (e.g., using `tmux` or multiple SSH sessions) and execute the following scripts:

- **Terminal 1 (Simulation & Firmware):** Generates the procedural environment (forest) and starts the PX4 SITL instance with Gazebo Garden in headless mode.
  ```bash
  ./workspace/scripts/launch_forest_headless.sh
  ```

- **Terminal 2 (ROS 2 Bridge):** Starts the `ros_gz_bridge` to expose Gazebo topics (such as the RGB and Depth camera streams from the `x500_depth` model) to the ROS 2 environment.
  ```bash
  ./workspace/scripts/run_camera_bridge.sh
  ```

- **Terminal 3 (Foxglove Bridge):** Starts the Foxglove WebSocket bridge, enabling external visualization tools to subscribe to ROS 2 topics.
  ```bash
  ./workspace/scripts/run_foxglove.sh
  ```

- **Terminal 4 (Micro-XRCE-DDS Agent):** Starts the DDS agent required for communication between the PX4 uORB messaging system and ROS 2.
  ```bash
  ./workspace/scripts/run_dds_agent.sh
  ```

### 4. Telemetry and Visualization

To visualize the data streams:
1. Launch Foxglove Studio on your local workstation.
2. Open a new connection and select "Foxglove WebSocket".
3. Enter the WebSocket URL: `ws://<SERVER_IP>:8765`.
4. Subscribe to the `/camera` and `/depth_camera` topics to view the simulation video feeds.

## Project Structure

- `.devcontainer/Dockerfile`: Instructions for building the complete environment stack.
- `.github/workflows/docker-build.yml`: CI/CD configuration. Triggers a build and push to Docker Hub only when the Dockerfile or workflow configuration is modified.
- `workspace/scripts/`: Initialization and orchestration bash scripts.
- `workspace/scripts/generate_forest.py`: Procedural SDF world generator script.
- `workspace/worlds/`: Output directory for generated Gazebo environment models.
