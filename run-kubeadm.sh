sudo kubeadm init

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl get all

kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

echo '

# Run the following on all worker nodes
# kubeadm join 192.168.60.141:6443 --token p0oqh0.9x8lbdlu0aa4wy70 \
         --discovery-token-ca-cert-hash sha256:8b4909f3f47a89b0be26e1f33c0015b13fe8bb5d671e3869582064538a4a32cf

'

