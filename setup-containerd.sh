#!/bin/bash
# https://kubernetes.io/docs/setup/production-environment/container-runtimes/

# Prerequisites
# Debian/Raspbian 10 or Debian/Raspbian 11
# Prepare the system install sudo and edit the /etc/hosts file
# apt-get update && apt-get install -y sudo
# vi /etc/hosts
# set the hostname to the IP address of the node

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

# Install containerd
# Uninstall old versions
sudo apt-get remove -y docker docker-engine docker.io containerd runc

# setup the repository
sudo apt-get update && sudo apt-get install -y ca-certificates curl gnupg lsb-release
# add the Docker GPG key
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
# set up the stable repository
echo \
"deb [arch=arm64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# install containerd
sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
# verify that containerd is installed correctly
sudo containerd --version
sudo docker run hello-world
sudo docker run hello-world | grep 'Hello from Docker!'
if [ $? -eq 0 ]; then
    echo "Congrats! containerd was installed successfully"
else
    echo "Oh no! containerd installation failed"
fi

# setup the config.toml file to configure containerd to use systemd cgroup driver
# https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd-configuration
sudo mkdir -p /etc/containerd
cat <<- TOML | sudo tee /etc/containerd/config.toml
version = 2
[plugins]
  [plugins."io.containerd.grpc.v1.cri"]
    [plugins."io.containerd.grpc.v1.cri".containerd]
      discard_unpacked_layers = true
      [plugins."io.containerd.grpc.v1.cri".containerd.runtimes]
        [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
          runtime_type = "io.containerd.runc.v2"
          [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
            SystemdCgroup = true
TOML

# Restart containerd
echo "Restarting containerd"
sudo systemctl restart containerd

# add the users to the docker group
echo "Adding users to the docker group"
sudo usermod -aG docker andres
