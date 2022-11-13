# https://kubernetes.io/docs/setup/production-environment/tools/
sudo apt-get update
#sudo apt-get install -y apt--https ca-certificates curl

sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

sudo swapoff -a
sudo sed -i -e '/swap/d' /etc/fstab
sudo systemctl mask dev-nvme0n1p3.swap

systemctl reboot
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

