ON ALL NODES
    1  apt install sudo git vim -y
    2  git clone https://github.com/onemanops/iac
    3  cd iac
    4  ls
    5  sudo ./setup-container.sh
    6  sudo ./setup-kubetools.sh
 
ON THE CONTROL NODE
    7  sudo kubeadm init
    8  #Copy the kubeadm join command, it contains a unique join token
    9  mkdir -p $HOME/.kube
   10  kubectl get all
   11  kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
 
ON THE WORKER NODES
    12  sudo kubeadm join 192.168.29.110:6443 --token i8o51d.zrqon1wqc19ozi69 \
        --discovery-token-ca-cert-hash sha256:6bc85310f8873946496a1ea8baea9ad34422298a7460be21248ffb2c9dda6c19
 
ON THE CONTROL NODE
   14  kubectl get nodes
 