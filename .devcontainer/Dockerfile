# VS Code Dev Container with Dart SDK and PX4 SITL
#
# Note: This Dockerfile is based on the official PX4 Docker containers
# and the official Dart Docker images.
#
# PX4 Docker containers: https://hub.docker.com/r/px4io/
# Dart Docker images: https://hub.docker.com/_/dart

# Use the PX4 simulation environment as the base
FROM px4io/px4-dev-simulation-focal:2022-07-31

# Install Dart SDK
# Ref: https://dart.dev/get-dart#install-using-the-apt-get-package-manager
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

RUN sh -c 'wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /usr/share/keyrings/dart.gpg'
RUN sh -c 'echo "deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main" > /etc/apt/sources.list.d/dart_stable.list'

RUN apt-get update && apt-get install -y dart

# Verify the Dart SDK installation
RUN dart --version

# Set up a non-root user
ARG USER_ID=1000
ARG GROUP_ID=1000
RUN groupadd -g $GROUP_ID vscode && \
    useradd -s /bin/bash -u $USER_ID -g $GROUP_ID -m vscode && \
    echo "vscode ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vscode && \
    chmod 0440 /etc/sudoers.d/vscode

# Set the default user
USER vscode

# Set the working directory
WORKDIR /home/vscode

# Clone PX4-Autopilot
RUN git clone https://github.com/PX4/PX4-Autopilot.git --recursive

# Set up environment for PX4
ENV PX4_HOME /home/vscode/PX4-Autopilot
ENV PATH=$PATH:$PX4_HOME/Tools

# Expose the necessary ports for SITL
EXPOSE 14570/udp

# Default command
CMD ["/bin/bash"]
