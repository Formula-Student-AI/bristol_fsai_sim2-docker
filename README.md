# Bristol FSAI Simulator 2 (Docker)

Bristol FSAI workspace built on top of [eufs_sim2](https://gitlab.com/eufs/public/eufs_sim2)
(EUFS's new ROS 2 Humble simulator that replaces the Gazebo-based `eufs_sim`).

This repo bundles every package needed to build and run the simulator, so a teammate
on Windows / macOS / Linux only needs **Docker Desktop + VSCode + the Dev Containers
extension** — no Ubuntu, no ROS install on the host.

## Versions

- OS in container: Ubuntu 22.04 (Jammy)
- ROS: ROS 2 Humble
- Visualisation: [Foxglove Studio](https://foxglove.dev/) via `foxglove_bridge` on port `8765`

## Contents

| Package | Source | Purpose |
| --- | --- | --- |
| `eufs_sim2` | gitlab.com/eufs/public/eufs_sim2 | Simulator core |
| `eufs_msgs` | gitlab.com/eufs/eufs_msgs | Message / service / action types |
| `eufs_logger` | gitlab.com/eufs/public/eufs-logger | Logging library |
| `eufs_gmock_matchers` | gitlab.com/eufs/public/eufs-gmock-matchers | Test matchers |
| `state_lib` | gitlab.com/eufs/public/state_lib | Vehicle state library |
| `map_lib` | gitlab.com/eufs/public/map_lib | Cone map / track library |
| `vehicle_models` | gitlab.com/eufs/public/vehicle_models | Vehicle dynamics models |
| `ros_can` | Bristol FSAI | FS-AI-API bridge for the real car |
| `foxglove_extensions/eufs_sim_foxglove_plugins` | gitlab.com/eufs/public/eufs-sim-foxglove-plugins | **Foxglove Studio** extension (not a ROS package) — renders `ConeArrayWithCovariance` and `CarForces` natively |

## Setup

1. Install [Docker Desktop](https://www.docker.com/products/docker-desktop/) and
   [VSCode](https://code.visualstudio.com/) with the **Dev Containers** extension.

2. Clone this repo:

   ```bash
   git clone https://github.com/Formula-Student-AI/bristol_fsai_sim2-docker.git
   cd bristol_fsai_sim2-docker
   ```

3. Open in VSCode and run **"Dev Containers: Reopen in Container"**
   (Ctrl/Cmd-Shift-P → type "reopen").

   First build takes ~5–10 min while the image installs ROS Humble + system deps.
   Subsequent opens are instant.

4. Inside the container, build the workspace:

   ```bash
   colcon build --symlink-install
   source install/setup.bash
   ```

5. Launch the simulator + Foxglove bridge:

   ```bash
   ros2 launch eufs_sim2 eufs_sim2.launch.py &
   ros2 run foxglove_bridge foxglove_bridge --ros-args -p port:=8765
   ```

6. From your host, open [Foxglove Studio](https://app.foxglove.dev/) and connect to
   `ws://localhost:8765`. Topics like `/odom`, `/cones`, `/imu/data`, `/cmd` should
   appear.

## Installing the Foxglove extension (one-time, host-side)

The simulator publishes EUFS-specific message types (`ConeArrayWithCovariance`,
`CarForces`) that Foxglove Studio cannot render natively. To get coloured cones and
wheel-force arrows, install the bundled extension **into Foxglove Studio on your host**
(not into the dev container — this is a frontend extension, not a ROS package).

**Easy path — drag-and-drop the pre-built `.foxe`:**

1. Open Foxglove Studio.
2. Drag
   [`foxglove_extensions/eufs_sim_foxglove_plugins/edinburghuniversityformulastudent.eufs-sim-foxglove-plugins-0.0.1.foxe`](foxglove_extensions/eufs_sim_foxglove_plugins/)
   onto the Foxglove window.
3. Reload — `ConeArrayWithCovariance` and `WheelForceArrows` panels are now available.

**Dev path — build from source** (only needed if you edit the plugin):

```bash
cd foxglove_extensions/eufs_sim_foxglove_plugins
npm install
npm run local-install   # installs into your host's Foxglove Studio
```

## Updating an EUFS package

Each EUFS package is a normal `git clone`, not a submodule. To pull upstream changes
for one of them:

```bash
cd eufs_sim2 && git pull && cd ..
colcon build --packages-select eufs_sim2 --symlink-install
```

## How to contribute

```bash
git checkout -b your_branch_name
# ... edit files (live, on host — symlink-install picks them up) ...
git add path/to/file
git commit -m "describe change"
git push -u origin your_branch_name
```

## Credit

- EUFS: <https://gitlab.com/eufs>
- Dev container template: [ijnek/ros-devcontainer-template](https://github.com/ijnek/ros-devcontainer-template)
- Original Bristol fork: [bristol_fsai_sim-docker](https://github.com/Formula-Student-AI/bristol_fsai_sim-docker) (eufs_sim 1, Galactic)
