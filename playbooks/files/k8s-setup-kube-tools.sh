#!/bin/bash

# setting MYOS variable
MYOS=$(hostnamectl | awk '/Operating/ { print $3 }')
OSVERSION=$(hostnamectl | awk '/Operating/ { print $4 }')

# detecting latest Kubernetes version
KUBEVERSION=$(curl -s https://api.github.com/repos/kubernetes/kubernetes/releases/latest | jq -r '.tag_name')
KUBEVERSION=${KUBEVERSION%.*}


if [ $MYOS = "Debian" ]
then
	echo RUNNING Debian CONFIG
	
	curl -fsSL https://pkgs.k8s.io/core:/stable:/${KUBEVERSION}/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
	echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${KUBEVERSION}/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sleep 2

	sudo apt-get update
	sudo apt-get install -y kubelet kubeadm kubectl
	sudo apt-mark hold kubelet kubeadm kubectl
	
fi


sudo crictl config --set \
    runtime-endpoint=unix:///run/containerd/containerd.sock
echo 'after initializing the control node, follow instructions and use kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml to install the calico plugin (control node only). On the worker nodes, use sudo kubeadm join ... to join'