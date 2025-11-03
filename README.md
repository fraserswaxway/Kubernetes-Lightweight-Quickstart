# Kubernetes-Lightweight-Quickstart
Quickstart on using K3S

### Abstract

Kubernetes (K8s) is a popular container conductor. That is, K8s
provides automation of container deployment and high availability
at scale. K8s  

deployment, scaling, and health
orchestrator 
orchestration
In general, Kubernetes requires hardware and some technical expertise.

If you have limited hardware or  
Some desktop variants for containers provide Kubernetes features


Kubernetes
Throughout my career there has been endless change and as a result endless learning.
I enjoy the challenge. Recently, I decided to refine my Infrastructure as Code (IaC)
skills by creating a project with the intent to write a simple how-to mixing Terradata (OpenTofu)
with KinD (Kubernetes in Docker) and a deployment of microservice using OpenFaaS Community Edition (CE).
The end result is documented at https://fraserswaxway.github.io/tofu-quick-start/ and all the files are
at https://github.com/fraserswaxway/tofu-quick-start. Most [somewhat] technical people should be
able to use the provided files and see a result in around 30 minutes.

### Contents
1. [Environment](#environment)
2. [Folder and Files](#folder)
3. [HashiCorp Configuration Language (HCL)](#hcl)<br>
   3.1 [Functions](#functions)<br>
   3.2 [Providers](#providers)<br>
   3.3 [Variables](#variables)<br>
   3.4 [Data](#data)<br>
   3.5 [Resource](#resource)<br>
4. [Command Line Interface (CLI) - Apply](#apply)
5. [cURL Validation](#curl)
6. [Command Line Interface (CLI) - Destroy](#destroy)
7. [Tips](#tips)
8. [References](#references)


### 1. Introduction <a id="introduction"/>


[K3s](https://docs.k3s.io/) is a lightweight version of Kubernetes (K3s) which runs on most modern 
Linux operating systems ([Requirements](https://docs.k3s.io/installation/requirements)).  
It is quick and easy to install. Installation of K3s directly with LXC (Linux Container) can be move involved 
([Mills, 2022](https://garrettmills.dev/blog/2022/04/18/Rancher-K3s-Kubernetes-on-Proxmox-Container/)).


A. nit



apt install curl podman -y
curl -sfL https://get.k3s.io | sh -
sed s/ReplaceWithHost/$(cat /etc/hostname)/g registry.yaml \
  | kubectl apply -f -
go build hello.go
podman build -t hello .
podman tag hello:latest $(cat /etc/hostname):5000/hello:latest
podman push --tls-verify=false $(cat /etc/hostname):5000/hello:latest
sed s/ReplaceWithHost/$(cat /etc/hostname)/g registries.yaml > /etc/rancher/k3s/registries.yaml
systemctl restart k3s

kubectl apply -n portainer -f https://downloads.portainer.io/ce-lts/portainer.yaml
http://192.168.1.2:30777/


https://192.168.1.430776

kubectl describe pod hello

kubectl get nodes

vi /etc/systemd/system/k3s.service
vi /etc/systemd/system/k3s.service.env



https://garrettmills.dev/blog/2022/04/18/Rancher-K3s-Kubernetes-on-Proxmox-Container/




quick to install 
Lightweight Kubernetes. Easy to install, half the memory, all in a binary of less than 100 MB.



(K3s)


Most human communication is sensory based. Block senses and
most communication is prevented. Many organizations practice
blocking senses to protect information. Most are familiar
the use of distance, walls, rooms, doors, curtains,
and soundproofing as physical barriers. Languages and codes
can also be barriers. 



![OSI 7 Layers](https://miro.medium.com/v2/resize:fit:720/format:webp/0*_APAwpghit64dMkW.png)


### 8. References <a id="references"/>


K3s - Lightweight Kubernetes. (2025). https://docs.k3s.io/

Requirements. (2025). https://docs.k3s.io/installation/requirements

Mills, G. (2022). _Kubernetes on Proxmox Containers_. 
https://garrettmills.dev/blog/2022/04/18/Rancher-K3s-Kubernetes-on-Proxmox-Container/



2015-2025 Garrett Mills — Technical Info

(n.d.)

K3s Project Authors. (2025). K3s - Lightweight Kubernetes. https://docs.k3s.io/

K3s Project Authors. (2025). K3s - Lightweight Kubernetes, 
Installation, Requirements. https://docs.k3s.io/installation/requirements


_K3s - Lightweight Kubernetes_. (n.d.). https://docs.k3s.io/



Copyright © 2025 K3s Project Authors. All rights reserved.




Grady, J. S., Her, M., Moreno, G., Perez, C., & Yelinek, J. (2019). 
Emotions in storybooks: A comparison of storybooks that represent ethnic 
and racial groups in the United States. Psychology of Popular Media Culture, 
8(3), 207–217. https://doi.org/10.1037/ppm0000185



References
https://kubernetes.io/docs/concepts/overview/

### About the Author

Stuart Fraser has a Master of Science in Computer Science from Old Dominion University and is a
consulting Principal Architect at [Axway](https://axway.com/).

### Acknowledgements

Special thanks to [Axway](https://axway.com/) for affording and enabling skills development.

