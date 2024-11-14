FROM ros:noetic-ros-base

RUN dpkg --add-architecture $(dpkg --print-architecture)

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
    git \
    gazebo11 \
    ros-noetic-gazebo-ros \
    ros-noetic-camera-info-manager \
    ros-noetic-compressed-image-transport \
    ros-noetic-ros-control \
    ros-noetic-ros-controllers \
    ros-noetic-joint-state-publisher \
    ros-noetic-joint-state-controller \
    ros-noetic-robot-state-publisher \
    ros-noetic-gmapping \
    ros-noetic-rviz \
    python3-pip \
    ros-noetic-robot-localization \
    ros-noetic-xacro \
    ros-noetic-tf2-ros \
    ros-noetic-tf2-tools \
    ros-noetic-rosbridge-server \
    libraspberrypi-bin \
    libraspberrypi-dev \
    python3-rosdep \
    && rm -rf /var/lib/apt/lists/*


RUN pip install RPi.GPIO
    
# Create an overlay Catkin workspace
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash \
    && mkdir -p /catkin_ws/src \
    && cd /catkin_ws/src \
    && catkin_init_workspace \
    && git clone -b noetic https://github.com/rigbetellabs/tortoisebot.git"

COPY gmapping.launch /catkin_ws/src/tortoisebot/tortoisebot_slam/launch/
COPY gmapping.rviz /catkin_ws/src/tortoisebot/tortoisebot_slam/rviz/


# Build the workspace
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash \
    && cd /catkin_ws \
    && catkin_make \
    && source /catkin_ws/devel/setup.bash \
    && echo 'source /catkin_ws/devel/setup.bash' >> ~/.bashrc"

# Set UP ENTRY
COPY ./slam_real-entrypoint.sh ./entrypoint.sh
RUN chmod +x entrypoint.sh

ENTRYPOINT ["/bin/bash"]
CMD ["./entrypoint.sh"]