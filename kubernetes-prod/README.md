## Основное задание
Узлы:
```shell
84.201.150.210  otus-mn-01
158.160.158.38  otus-wn-01
158.160.193.164 otus-wn-02
158.160.176.82  otus-wn-03
```

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

Обновление до версии 1.32  
На мастер ноде:
```shell
sudo sed -i 's/1.31/1.32/g' /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt-cache madison kubeadm
sudo apt-mark unhold kubeadm kubelet kubectl&& \
sudo apt-get update && sudo apt-get install -y kubeadm='1.32.7-1.1' kubelet='1.32.7-1.1' kubectl='1.32.7-1.1' && \
sudo apt-mark hold kubeadm kubelet kubectl
sudo kubeadm upgrade plan
```
Вывод:
```shell
[upgrade] SUCCESS! A control plane node of your cluster was upgraded to "v1.32.7".
```
Последовательно освобождаем каждую воркер ноду и обновляем:
```shell
mn: kubectl drain otus-wn-01 --ignore-daemonsets
wn: 
sudo sed -i 's/1.31/1.32/g' /etc/apt/sources.list.d/kubernetes.list 
sudo apt-mark unhold kubelet kubectl && \
sudo apt-get update && sudo apt-get install -y kubelet='1.32.7-1.1' kubectl='1.32.7-1.1' && \
sudo apt-mark hold kubelet kubectl
mn: kubectl uncordon otus-wn-01
```
Проверка:
```shell
kubectl get no -o wide
```
Вывод:
```shell
NAME         STATUS   ROLES           AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
otus-mn-01   Ready    control-plane   9h    v1.32.7   10.130.0.19   <none>        Ubuntu 24.04.2 LTS   6.8.0-63-generic   containerd://1.7.27
otus-wn-01   Ready    <none>          9h    v1.32.7   10.130.0.23   <none>        Ubuntu 24.04.2 LTS   6.8.0-64-generic   containerd://1.7.27
otus-wn-02   Ready    <none>          9h    v1.32.7   10.130.0.4    <none>        Ubuntu 24.04.2 LTS   6.8.0-64-generic   containerd://1.7.27
otus-wn-03   Ready    <none>          9h    v1.32.7   10.130.0.15   <none>        Ubuntu 24.04.2 LTS   6.8.0-64-generic   containerd://1.7.27
```

## Задание со *
Узлы:
```shell
84.201.150.210  otus-mn-01
158.160.176.82  otus-mn-02
158.160.175.69  otus-mn-03
158.160.158.38  otus-wn-01
158.160.193.164 otus-wn-02
```
Запуск плейбука
```shell
ansible-playbook -i /inventory/inventory.ini --private-key /root/.ssh/id_rsa -u kst --become  cluster.yml
```
Проверка:
```shell
sudo kubectl get no -o wide
```
Вывод:
```shell
NAME         STATUS   ROLES           AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
otus-mn-01   Ready    control-plane   11m   v1.32.5   10.130.0.19   <none>        Ubuntu 24.04.2 LTS   6.8.0-63-generic   containerd://2.0.5
otus-mn-02   Ready    control-plane   11m   v1.32.5   10.130.0.35   <none>        Ubuntu 24.04.2 LTS   6.8.0-63-generic   containerd://2.0.5
otus-mn-03   Ready    control-plane   11m   v1.32.5   10.130.0.10   <none>        Ubuntu 24.04.2 LTS   6.8.0-63-generic   containerd://2.0.5
otus-wn-01   Ready    <none>          10m   v1.32.5   10.130.0.23   <none>        Ubuntu 24.04.2 LTS   6.8.0-64-generic   containerd://2.0.5
otus-wn-02   Ready    <none>          10m   v1.32.5   10.130.0.4    <none>        Ubuntu 24.04.2 LTS   6.8.0-64-generic   containerd://2.0.5
```