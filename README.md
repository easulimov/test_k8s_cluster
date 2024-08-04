
# Тестовый кластер k8s на ОС Debian 12

Ссылки:
https://habr.com/ru/articles/725640/
https://habr.com/ru/companies/slurm/articles/439562/
https://github.com/sandervanvugt/cka


### Инициализация первой мастеры ноды

В --control-plane-endpoint указываем VIP

```
kubeadm init \
               --pod-network-cidr=10.2.0.0/16 \
               --control-plane-endpoint "192.168.8.60:8888" \
               --upload-certs
```

В результате должен быть получен такой вывод:

```
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of the control-plane node running the following command on each as root:

  kubeadm join 192.168.8.60:8888 --token r95249.cxp1qiawa5m3j39n \
	--discovery-token-ca-cert-hash sha256:0149c7256cd481ef25ad80755234928a7f1647e3c928ac71ad711ab9b9c34c9c \
	--control-plane --certificate-key e03110ca9024b81f62422e17bc2839f93c7b9cb35535bd27d66e4f8ade9cb5d2

Please note that the certificate-key gives access to cluster sensitive data, keep it secret!
As a safeguard, uploaded-certs will be deleted in two hours; If necessary, you can use
"kubeadm init phase upload-certs --upload-certs" to reload certs afterward.

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.8.60:8888 --token r95249.cxp1qiawa5m3j39n \
	--discovery-token-ca-cert-hash sha256:0149c7256cd481ef25ad80755234928a7f1647e3c928ac71ad711ab9b9c34c9c 

```

### Добавление мастер нод

На каждой мастер ноде выполните

```
  kubeadm join 192.168.8.60:8888 --token r95249.cxp1qiawa5m3j39n \
	--discovery-token-ca-cert-hash sha256:0149c7256cd481ef25ad80755234928a7f1647e3c928ac71ad711ab9b9c34c9c \
	--control-plane --certificate-key e03110ca9024b81f62422e17bc2839f93c7b9cb35535bd27d66e4f8ade9cb5d2
```

### Добавление воркер нод

На каждой мастер ноде выполните

```
kubeadm join 192.168.8.60:8888 --token r95249.cxp1qiawa5m3j39n \
	--discovery-token-ca-cert-hash sha256:0149c7256cd481ef25ad80755234928a7f1647e3c928ac71ad711ab9b9c34c9c 
```

### Настройка kubectl

На мастер нодах выполните

```
echo "export KUBECONFIG=/etc/kubernetes/admin.conf" > /etc/environment
export KUBECONFIG=/etc/kubernetes/admin.conf
```

### Применение сетевого плагина Calico

На мастер ноде примените команду

```
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/calico.yaml
```