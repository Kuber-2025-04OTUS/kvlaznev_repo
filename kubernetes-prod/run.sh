#!/bin/bash
for nodes in otus-mn-01 otus-wn-01 otus-wn-02 otus-wn-03; do 
    printf "\n\033[31m=== Working with node: %s ===\033[0m\n\n" "$nodes"
    ssh -t $nodes "
    sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl gpg
    sudo mkdir -p -m 755 /etc/apt/keyrings
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | \
    sudo gpg --batch --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | \
    sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y containerd.io kubelet kubeadm kubectl
    sudo apt-mark hold kubelet kubeadm kubectl
    sudo systemctl enable --now kubelet
    echo "br_netfilter" | sudo tee /etc/modules-load.d/k8s.conf
    echo "net.ipv4.ip_forward=1" | sudo tee /etc/sysctl.d/99-k8s.conf
    sudo containerd config default | sudo tee /etc/containerd/config.toml
    sudo sed -i  's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
    wget https://github.com/containernetworking/plugins/releases/download/v1.7.1/cni-plugins-linux-amd64-v1.7.1.tgz
    sudo mkdir -p /opt/cni/bin
    sudo tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.7.1.tgz
    sudo reboot
    "
done