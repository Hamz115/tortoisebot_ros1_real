#!/bin/bash

# First source the ROS Noetic setup
source /opt/ros/noetic/setup.bash

# Then source your workspace setup
source /catkin_ws/devel/setup.bash

# Launch the bring up
roslaunch tortoisebot_firmware server_bringup.launch &

sleep 5s

# Launch gmapping SLAM
roslaunch tortoisebot_slam gmapping.launch &

sleep 5s

# Launch sensor visualization
roslaunch tortoisebot_slam view_sensors.launch

# Execute the command passed into this entrypoint
exec "$@"