# Containers in Lightweight Kubernetes (K3S) | Jive

[![Stuart Fraser](https://axway.jiveon.com/api/core/v3/people/4418/avatar?a=6358&amp;width=144&amp;height=144 "Stuart Fraser")](/people/sfraser%40axway.com "Stuart Fraser")

# Containers in Lightweight Kubernetes (K3S)

Blog Post created by [Stuart Fraser](/people/sfraser%40axway.com) on Mar 11, 2026  

-   Like • Show 2 Likes[2](# "Show 2 Likes")
-   [Comment](#comments) • [0](#comments)

\*\*\*\*\* **NEW** 15-MINUTE VIDEO: [YouTube](https://axway.jiveon.com/external-link.jspa?url=https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DPHTMiXBmeYw) \*\*\*\*\*

**CONTENTS**

-   -   [1\. Host](#jive_content_id_1_Host)
    -   [2\. Tools](#jive_content_id_2_Tools)
    -   [3\. Light Kubernetes (K3S)](#jive_content_id_3_Light_Kubernetes_K3S)
    -   [4\. (OPTIONAL) Portainer](#jive_content_id_4_OPTIONAL_Portainer)
    -   [5\. Registry](#jive_content_id_5_Registry)
        -   [5.1. Install](#jive_content_id_51_Install)
        -   [5.2. Download Certificate Authority](#jive_content_id_52_Download_Certificate_Authority)
        -   [5.3. Configure Registries](#jive_content_id_53_Configure_Registries)
        -   [5.4. Restart Virtual Machine](#jive_content_id_54_Restart_Virtual_Machine)
    -   [6\. Container Image](#jive_content_id_6_Container_Image)
        -   [6.1. Create hello.go](#jive_content_id_61_Create_hellogo)
        -   [6.2. Create Containerfile](#jive_content_id_62_Create_Containerfile)
        -   [6.3. Create Image](#jive_content_id_63_Create_Image)
        -   [6.4. Login Repository](#jive_content_id_64_Login_Repository)
        -   [6.5. Push Image to Repository](#jive_content_id_65_Push_Image_to_Repository)
    -   [7\. Deploy](#jive_content_id_7_Deploy)
        -   [7.1. Create hello.yaml](#jive_content_id_71_Create_helloyaml)
        -   [7.2. Apply](#jive_content_id_72_Apply)
    -   [8\. Use](#jive_content_id_8_Use)
    -   [9\. Script](#jive_content_id_9_Script)
        -   [9.1. Create file kube.sh](#jive_content_id_91_Create_file_kubesh)
        -   [9.2. Run](#jive_content_id_92_Run)
    -   [10\. Additional](#jive_content_id_10_Additional)
    

This post focuses on selected operating systems and tools. It can be adapted to others as well. Using the selected tools may avoid introducing challenges while still promoting skills and understanding.

### 1\. Host

Create a virtual machine (VM) in Axway pcloud using the latest release available for the Debian operating system (OS).

**NOTE:** Consider a large (XL) configuration.

### 2\. Tools

```
systemctl stop xagtsystemctl disable xagtapt update -yapt upgrade -yapt autoremove -yapt install curl git podman -ymkdir -p /opt/cni/binwget https://github.com$(curl -s https://github.com/containernetworking/plugins/releases \  | grep download | grep amd64 | grep tgz\" | sed -n 's/.*href=\"\(\S*\)\".*/\1/p')tar -xvf cni-plugins-linux-amd64-*.tgz -C /opt/cni/bin/curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash -
```

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
helm repo add harbor https://helm.goharbor.ioKUBECONFIG=/etc/rancher/k3s/k3s.yaml \  helm install registry harbor/harbor \  --set expose.type=ingress \  --set expose.ingress.hosts.core=$(hostname -f | tr '[:upper:]' '[:lower:]') \  --set externalURL=https://$(hostname -f | tr '[:upper:]' '[:lower:]')
```

**NOTE:** One can view the registry at https://<VM>.

#### 5.2. Download Certificate Authority

```
mkdir -p /root/usr/local/share/ca-certificates/$(hostname -f | tr '[:upper:]' '[:lower:]') \  && curl -s -k https://$(hostname -f | tr '[:upper:]' '[:lower:]')/api/v2.0/systeminfo/getcert \  > /root/usr/local/share/ca-certificates/$(hostname -f | tr '[:upper:]' '[:lower:]')/ca.crt
```

#### 5.3. Configure Registries

```
sed s/ReplaceWithHost/$(hostname -f | tr '[:upper:]' '[:lower:]')/g <<EOF \  | sed s/ReplaceWithIP/$(hostname -I | cut -f1 -d' ')/g \  > /etc/rancher/k3s/registries.yamlmirrors:  "ReplaceWithIP":    endpoints:      - "http://ReplaceWithIP"  "ReplaceWithHost:5000":    endpoints:      - "http://ReplaceWithHost"configs:  "ReplaceWithHost":    tls:      ca_file: "/root/usr/local/share/ca-certificates/ReplaceWithHost/ca.crt"EOF
```

#### 5.4. Restart Virtual Machine

```
reboot
```

### 6\. Container Image

#### 6.1. Create hello.go

Here's a tiny bit of Go language which will reply with "hello" if the hello path is called on a HTTP listener. 

No need to install Go language. Compiling will be done inside the container during configuration.

```
package mainimport (    "fmt"    "net/http")func hello(w http.ResponseWriter, req *http.Request) {    fmt.Fprintf(w, "hello\n")}func main() {    http.HandleFunc("/hello", hello)    http.ListenAndServe(":8080", nil)}
```

#### 6.2. Create Containerfile

```
FROM registry-1.docker.io/library/golang:latestCOPY ./hello.go hello.goRUN go build -o /bin/hello hello.goCMD ["hello"]
```

**NOTE:** The container is based on and included Go language. The **"RUN go build..."** compiles the source to /bin/hello (bin is in the default PATH for the container.

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

```
apiVersion: v1kind: Secretmetadata:  name: registry-secrettype: OpaquestringData:  username: admin  password: Harbor12345---apiVersion: apps/v1kind: Deploymentmetadata:  name: hello  labels:    app: hellospec:  replicas: 1  selector:    matchLabels:      app: hello  template:    metadata:      labels:        app: hello    spec:      containers:        - name: hello          image: ReplaceWithHost/library/hello:latest          ports:            - containerPort: 8080      imagePullSecrets:        - name: registry-secret      restartPolicy: Always---apiVersion: v1kind: Servicemetadata:  name: hellospec:  selector:    app: hello  ports:    - protocol: TCP      port: 80 # clusterIP port      targetPort: 8080 # process port      nodePort: 30080 #external  type: NodePort
```

#### 7.2. Apply

```
KUBECONFIG=/etc/rancher/k3s/k3s.yaml \  sed s/ReplaceWithHost/$(hostname -f \  | tr '[:upper:]' '[:lower:]')/g hello.yaml \  | kubectl apply -f - --insecure-skip-tls-verify=true
```

### 8\. Use

```
curl -k http://$(hostname -f | tr '[:upper:]' '[:lower:]'):30080/hello
```

### 9\. Script

The following script does it all.

#### 9.1. Create file kube.sh

```
#!/bin/bashsystemctl stop xagtsystemctl disable xagtDEBIAN_FRONTEND=noninteractive apt update -yDEBIAN_FRONTEND=noninteractive apt upgrade -yDEBIAN_FRONTEND=noninteractive apt autoremove -yDEBIAN_FRONTEND=noninteractive apt install curl git podman -ymkdir -p /opt/cni/binwget https://github.com$(curl -s https://github.com/containernetworking/plugins/releases \  | grep download | grep amd64 | grep tgz\" | sed -n 's/.*href=\"\(\S*\)\".*/\1/p')tar -xvf cni-plugins-linux-amd64-*.tgz -C /opt/cni/bin/curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash -curl -sfL https://get.k3s.io | sh -SECONDS_LEFT=45while [ $SECONDS_LEFT -gt 0 ]; do    printf "\rShort pause: %02d" "$SECONDS_LEFT"    sleep 1    SECONDS_LEFT=$((SECONDS_LEFT - 1))doneecho ""helm repo add harbor https://helm.goharbor.ioKUBECONFIG=/etc/rancher/k3s/k3s.yaml \  helm install registry harbor/harbor \  --set expose.type=ingress \  --set expose.ingress.hosts.core=$(hostname -f | tr '[:upper:]' '[:lower:]') \  --set externalURL=https://$(hostname -f | tr '[:upper:]' '[:lower:]')SECONDS_LEFT=45while [ $SECONDS_LEFT -gt 0 ]; do    printf "\rShort pause: %02d" "$SECONDS_LEFT"    sleep 1    SECONDS_LEFT=$((SECONDS_LEFT - 1))doneecho ""mkdir -p /root/usr/local/share/ca-certificates/$(hostname -f | tr '[:upper:]' '[:lower:]') \  && curl -s -k https://$(hostname -f | tr '[:upper:]' '[:lower:]')/api/v2.0/systeminfo/getcert \  > /root/usr/local/share/ca-certificates/$(hostname -f | tr '[:upper:]' '[:lower:]')/ca.crtsed s/ReplaceWithHost/$(hostname -f | tr '[:upper:]' '[:lower:]')/g <<EOF \  | sed s/ReplaceWithIP/$(hostname -I | cut -f1 -d' ')/g \  > /etc/rancher/k3s/registries.yamlmirrors:  "ReplaceWithIP":    endpoints:      - "http://ReplaceWithIP"  "ReplaceWithHost:5000":    endpoints:      - "http://ReplaceWithHost"configs:  "ReplaceWithHost":    tls:      ca_file: "/root/usr/local/share/ca-certificates/ReplaceWithHost/ca.crt"EOFsystemctl restart k3scat <<EOF > hello.gopackage mainimport (    "fmt"    "net/http")func hello(w http.ResponseWriter, req *http.Request) {    fmt.Fprintf(w, "hello\n")}func main() {    http.HandleFunc("/hello", hello)    http.ListenAndServe(":8080", nil)}EOFcat <<EOF > ContainerfileFROM registry-1.docker.io/library/golang:latestCOPY ./hello.go hello.goRUN go build -o /bin/hello hello.goCMD ["hello"]EOFpodman build -t $(hostname -f | tr '[:upper:]' '[:lower:]')/library/hello:latest .podman login --tls-verify=false $(hostname -f | tr '[:upper:]' '[:lower:]') --username admin --password Harbor12345podman push --tls-verify=false $(hostname -f | tr '[:upper:]' '[:lower:]')/library/hello:latestSECONDS_LEFT=45while [ $SECONDS_LEFT -gt 0 ]; do    printf "\rShort pause: %02d" "$SECONDS_LEFT"    sleep 1    SECONDS_LEFT=$((SECONDS_LEFT - 1))doneecho ""cat <<EOF > hello.yamlapiVersion: v1kind: Secretmetadata:  name: registry-secrettype: OpaquestringData:  username: admin  password: Harbor12345---apiVersion: apps/v1kind: Deploymentmetadata:  name: hello  labels:    app: hellospec:  replicas: 1  selector:    matchLabels:      app: hello  template:    metadata:      labels:        app: hello    spec:      containers:        - name: hello          image: ReplaceWithHost/library/hello:latest          ports:            - containerPort: 8080      imagePullSecrets:        - name: registry-secret      restartPolicy: Always---apiVersion: v1kind: Servicemetadata:  name: hellospec:  selector:    app: hello  ports:    - protocol: TCP      port: 80 # clusterIP port      targetPort: 8080 # process port      nodePort: 30080 #external  type: NodePortEOFKUBECONFIG=/etc/rancher/k3s/k3s.yaml \  sed s/ReplaceWithHost/$(hostname -f \  | tr '[:upper:]' '[:lower:]')/g hello.yaml \  | kubectl apply -f - --insecure-skip-tls-verify=trueSECONDS_LEFT=45while [ $SECONDS_LEFT -gt 0 ]; do    printf "\rShort pause: %02d" "$SECONDS_LEFT"    sleep 1    SECONDS_LEFT=$((SECONDS_LEFT - 1))doneecho ""curl -k http://$(hostname -f | tr '[:upper:]' '[:lower:]'):30080/hello  
```

#### 9.2. Run

```
chmod +x kube.sh ; ./kube.sh
```

### 10\. Additional

Others posts which may be of interest:[Setup of Rancher and Kubernetes on Axway PCloud](https://axway.jiveon.com/people/aholmes@axway.com/blog/2023/05/15/setup-of-rancher-and-kubernetes-on-axway-pcloud)

-   [Setup of Rancher and Kubernetes on Axway PClou](https://axway.jiveon.com/people/aholmes@axway.com/blog/2023/05/15/setup-of-rancher-and-kubernetes-on-axway-pcloud)d
-   [https://git.ecd.axway.org/ajones/b2bi-k8s](https://axway.jiveon.com/external-link.jspa?url=https%3A%2F%2Fgit.ecd.axway.org%2Fajones%2Fb2bi-k8s) 

## Outcomes
