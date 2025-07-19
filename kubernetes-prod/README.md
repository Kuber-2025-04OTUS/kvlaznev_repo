84.201.150.210  otus-mn-01
158.160.158.38  otus-wn-01
158.160.193.164 otus-wn-02
158.160.176.82  otus-wn-03

На мастер ноде:
```shell
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```

Вывод:
```shell
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

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 10.130.0.19:6443 --token ktjzbv.42wnr334ts7zjr9x \
        --discovery-token-ca-cert-hash sha256:0e7656c15a50dd23d1b28670df300f6d31f65f093f1ccafbf2e33fc80a356406 
```

Устанавливаем Flannel
```shell
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
```
Вывод:
```shell
namespace/kube-flannel created
serviceaccount/flannel created
clusterrole.rbac.authorization.k8s.io/flannel created
clusterrolebinding.rbac.authorization.k8s.io/flannel created
configmap/kube-flannel-cfg created
daemonset.apps/kube-flannel-ds created
```
Проверка:
```shell
kubectl get no -o wide
```
Вывод:
```shell
NAME         STATUS   ROLES           AGE   VERSION    INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
otus-mn-01   Ready    control-plane   16m   v1.31.11   10.130.0.19   <none>        Ubuntu 24.04.2 LTS   6.8.0-63-generic   containerd://1.7.27
```

На воркерах:
```shell
sudo kubeadm join otus-mn-01:6443 --token ktjzbv.42wnr334ts7zjr9x \
        --discovery-token-ca-cert-hash sha256:0e7656c15a50dd23d1b28670df300f6d31f65f093f1ccafbf2e33fc80a356406 
```        
Вывод:
```shell
NAME         STATUS   ROLES           AGE     VERSION    INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
otus-mn-01   Ready    control-plane   37m     v1.31.11   10.130.0.19   <none>        Ubuntu 24.04.2 LTS   6.8.0-63-generic   containerd://1.7.27
otus-wn-01   Ready    <none>          8m14s   v1.31.11   10.130.0.23   <none>        Ubuntu 24.04.2 LTS   6.8.0-64-generic   containerd://1.7.27
otus-wn-02   Ready    <none>          3m57s   v1.31.11   10.130.0.4    <none>        Ubuntu 24.04.2 LTS   6.8.0-64-generic   containerd://1.7.27
otus-wn-03   Ready    <none>          64s     v1.31.11   10.130.0.15   <none>        Ubuntu 24.04.2 LTS   6.8.0-64-generic   containerd://1.7.27
```

