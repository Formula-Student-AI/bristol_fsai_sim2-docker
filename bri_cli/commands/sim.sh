#!/usr/bin/env bash
# desc: run the simulator (subcommands: run)

set -euo pipefail

SUBCMD="${1:-help}"
shift || true

case "$SUBCMD" in
    run)
        source /opt/ros/humble/setup.bash
        cd "$EUFS_MASTER"

        if [[ ! -f install/setup.bash ]]; then
            echo "bri sim run: workspace is not built yet." >&2
            echo "Run 'bri build' first." >&2
            exit 1
        fi
        source install/setup.bash

        # foxglove_bridge is started as a background service by the dev container
        # (see .devcontainer/devcontainer.json postStartCommand). Here we only
        # launch the simulator so its logs aren't interleaved with the bridge.
        exec ros2 launch eufs_sim2 eufs_sim2.launch.py "$@"
        ;;
    -h|--help|help|"")
        cat <<EOF
bri sim — simulator control

Usage:
  bri sim run [launch_args...]   Launch eufs_sim2.launch.py

The foxglove_bridge is auto-started by the dev container on ws://localhost:8765;
no need to launch it manually. Tail its log with:
    tail -f /tmp/foxglove_bridge.log
EOF
        ;;
    *)
        echo "bri sim: unknown subcommand '$SUBCMD'" >&2
        exit 1
        ;;
esac
