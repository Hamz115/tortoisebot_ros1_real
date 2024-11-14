#!/bin/bash


# First source the ROS Noetic setup
source /opt/ros/noetic/setup.bash

# Then source your workspace setup
source /catkin_ws/devel/setup.bash

# Launch the bring up
roslaunch tortoisebot_firmware bringup.launch


# Execute the command passed into this entrypoint
exec "$@"