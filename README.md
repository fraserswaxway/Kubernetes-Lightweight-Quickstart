# Containers in Lightweight Kubernetes (K3S)

**CONTENTS**

[1\. Host](#1-host)  
[2\. Tools](#2-tools)  
[3\. Light Kubernetes (K3S)](#3-light-kubernetes-k3s)  
[4\. (OPTIONAL) Portainer](#4-optional-portainer)  
[5\. Registry](#5-registry)  
&nbsp;&nbsp;&nbsp;&nbsp;[5.1. Install](#51-install)  
&nbsp;&nbsp;&nbsp;&nbsp;[5.2. Download Certificate Authority](#52-download-certificate-authority)  
&nbsp;&nbsp;&nbsp;&nbsp;[5.3. Configure Registries](#53-configure-registries)  
&nbsp;&nbsp;&nbsp;&nbsp;[5.4. Restart Virtual Machine](#54-restart-virtual-machine)  
[6\. Container Image](#6-container-image)  
&nbsp;&nbsp;&nbsp;&nbsp;[6.1. Create hello.go](#61-create-hellogo)  
&nbsp;&nbsp;&nbsp;&nbsp;[6.2. Create Containerfile](#62-create-containerfile)  
&nbsp;&nbsp;&nbsp;&nbsp;[6.3. Create Image](#63-create-image)  
&nbsp;&nbsp;&nbsp;&nbsp;[6.4. Login Repository](#64-login-repository)  
&nbsp;&nbsp;&nbsp;&nbsp;[6.5. Push Image to Repository](#65-push-image-to-repository)    
[7\. Deploy](#7-deploy)  
&nbsp;&nbsp;&nbsp;&nbsp;[7.1. Create hello.yaml](#71-create-helloyaml)    
&nbsp;&nbsp;&nbsp;&nbsp;[7.2. Apply](#72-apply)  
[8\. Use](#8-use)  
[9\. Script](#9-script-)  
    
This post focuses on selected operating systems and tools. It can be adapted to others as well. Using the selected tools may avoid introducing challenges while still promoting skills and understanding.

### 1\. Host

Start from the latest release available for the Debian operating system (OS).

**NOTE:**
- Consider 8 vCPU, 16 GB RAM, and 64 GB disk.

### 2\. Tools

\. [tools.sh](tools.sh)

### 3\. Light Kubernetes (K3S)

```
curl -sfL https://get.k3s.io | sh -
```

### 4\. (OPTIONAL) Portainer

```
kubectl apply -n portainer -f https://downloads.portainer.io/ce-lts/portainer.yaml
```

**IMPORTANT:** The admin password must be set within minutes at https://<VM>:30779.

### 5\. Registry

#### 5.1. Install

```
helm repo add harbor https://helm.goharbor.io
KUBECONFIG=/etc/rancher/k3s/k3s.yaml \
  helm install registry harbor/harbor \
  --set expose.type=ingress \
  --set expose.ingress.hosts.core=$(hostname -f | tr '[:upper:]' '[:lower:]') \
  --set externalURL=https://$(hostname -f | tr '[:upper:]' '[:lower:]')
```

**NOTE:**
- One can view the registry at https://yourcomputername.

#### 5.2. Download Certificate Authority

```
mkdir -p /root/usr/local/share/ca-certificates/$(hostname -f | tr '[:upper:]' '[:lower:]') \
  && curl -s -k https://$(hostname -f | tr '[:upper:]' '[:lower:]')/api/v2.0/systeminfo/getcert \
  > /root/usr/local/share/ca-certificates/$(hostname -f | tr '[:upper:]' '[:lower:]')/ca.crt
```

#### 5.3. Configure Registries

```bash
sed s/ReplaceWithHost/$(hostname -f | tr '[:upper:]' '[:lower:]')/g <<EOF \
  | sed s/ReplaceWithIP/$(hostname -I | cut -f1 -d' ')/g \
  > /etc/rancher/k3s/registries.yaml
mirrors:
  "ReplaceWithIP":
    endpoints:
      - "http://ReplaceWithIP"
  "ReplaceWithHost:5000":
    endpoints:
      - "http://ReplaceWithHost"
configs:
  "ReplaceWithHost":
    tls:
      ca_file: "/root/usr/local/share/ca-certificates/ReplaceWithHost/ca.crt"
EOF    
```

#### 5.4. Restart Virtual Machine

```
reboot
```

### 6\. Container Image

#### 6.1. Create hello.go

Here's a tiny bit of Go language which will reply with "hello" if the hello path is called on a HTTP listener. 

[hello.go](hello.go)

No need to install Go language. Compiling will be done inside the container during configuration.

#### 6.2. Create Containerfile

[Containerfile](Containerfile)

**NOTE:**
- The container is based on and included Go language.
- The "__RUN go build...__" compiles the source to /bin/hello (bin is in the default PATH for the container.

#### 6.3. Create Image

```
podman build -t $(hostname -f | tr '[:upper:]' '[:lower:]')/library/hello:latest .
```

#### 6.4. Login Repository

```
podman login --tls-verify=false $(hostname -f | tr '[:upper:]' '[:lower:]')
```

**IMPORTANT:**

-   Username: **admin**
-   Password: **Harbor12345**  
      
    

#### 6.5. Push Image to Repository

```
podman push --tls-verify=false $(hostname -f | tr '[:upper:]' '[:lower:]')/library/hello:latest
```

### 7\. Deploy

#### 7.1. Create hello.yaml

[hello.yaml](hello.yaml)

#### 7.2. Apply

```bash
KUBECONFIG=/etc/rancher/k3s/k3s.yaml \
  sed s/ReplaceWithHost/$(hostname -f \
  | tr '[:upper:]' '[:lower:]')/g hello.yaml \
  | kubectl apply -f - --insecure-skip-tls-verify=true
```

### 8\. Use

```bash
curl -k http://$(hostname -f | tr '[:upper:]' '[:lower:]'):30080/hello
```

### 9\. Script 

The following script does it all.

[kube.sh](kube.sh)


```
chmod +x kube.sh ; ./kube.sh
```
