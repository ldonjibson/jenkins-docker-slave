FROM ubuntu:24.04

# Update package repository and install necessary packages
RUN apt-get update && \
    apt-get install -qy git openssh-server default-jdk maven python3.12 python3.12-dev python3.12-venv python3-pip && \
    # Configure SSH
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd && \
    # Add user jenkins to the image
    adduser --quiet jenkins && \
    echo "jenkins:password" | chpasswd && \
    mkdir -p /home/jenkins/.m2 /home/jenkins/.ssh && \
    # Cleanup
    apt-get -qy autoremove && \
    rm -rf /var/lib/apt/lists/*

# Copy authorized keys
COPY .ssh/authorized_keys /home/jenkins/.ssh/authorized_keys

# Set permissions
RUN chown -R jenkins:jenkins /home/jenkins/.m2 /home/jenkins/.ssh

# Standard SSH port
EXPOSE 22

# Start SSH server
CMD ["/usr/sbin/sshd", "-D"]
