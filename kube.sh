#!/bin/bash
systemctl stop xagt
systemctl disable xagt
DEBIAN_FRONTEND=noninteractive apt update -y
DEBIAN_FRONTEND=noninteractive apt upgrade -y
DEBIAN_FRONTEND=noninteractive apt autoremove -y
DEBIAN_FRONTEND=noninteractive apt install curl git podman -y
mkdir -p /opt/cni/bin
wget https://github.com$(curl -s https://github.com/containernetworking/plugins/releases \
  | grep download | grep amd64 | grep tgz\" | sed -n 's/.*href=\"\(\S*\)\".*/\1/p')
tar -xvf cni-plugins-linux-amd64-*.tgz -C /opt/cni/bin/
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash -
curl -sfL https://get.k3s.io | sh -
SECONDS_LEFT=45
while [ $SECONDS_LEFT -gt 0 ]; do
    printf "\rShort pause: %02d" "$SECONDS_LEFT"
    sleep 1
    SECONDS_LEFT=$((SECONDS_LEFT - 1))
done
echo ""
helm repo add harbor https://helm.goharbor.io
KUBECONFIG=/etc/rancher/k3s/k3s.yaml \
  helm install registry harbor/harbor \
  --set expose.type=ingress \
  --set expose.ingress.hosts.core=$(hostname -f | tr '[:upper:]' '[:lower:]') \
  --set externalURL=https://$(hostname -f | tr '[:upper:]' '[:lower:]')
SECONDS_LEFT=45
while [ $SECONDS_LEFT -gt 0 ]; do
    printf "\rShort pause: %02d" "$SECONDS_LEFT"
    sleep 1
    SECONDS_LEFT=$((SECONDS_LEFT - 1))
done
echo ""
mkdir -p /root/usr/local/share/ca-certificates/$(hostname -f | tr '[:upper:]' '[:lower:]') \
  && curl -s -k https://$(hostname -f | tr '[:upper:]' '[:lower:]')/api/v2.0/systeminfo/getcert \
  > /root/usr/local/share/ca-certificates/$(hostname -f | tr '[:upper:]' '[:lower:]')/ca.crt
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
systemctl restart k3s
cat <<EOF > hello.go
package main
import (
    "fmt"
    "net/http"
)
func hello(w http.ResponseWriter, req *http.Request) {
    fmt.Fprintf(w, "hello\n")
}
func main() {
    http.HandleFunc("/hello", hello)
    http.ListenAndServe(":8080", nil)
}
EOF
cat <<EOF > Containerfile
FROM registry-1.docker.io/library/golang:latest
COPY ./hello.go hello.go
RUN go build -o /bin/hello hello.go
CMD ["hello"]
EOF
podman build -t $(hostname -f | tr '[:upper:]' '[:lower:]')/library/hello:latest .
podman login --tls-verify=false $(hostname -f | tr '[:upper:]' '[:lower:]') --username admin --password Harbor12345
podman push --tls-verify=false $(hostname -f | tr '[:upper:]' '[:lower:]')/library/hello:latest
SECONDS_LEFT=45
while [ $SECONDS_LEFT -gt 0 ]; do
    printf "\rShort pause: %02d" "$SECONDS_LEFT"
    sleep 1
    SECONDS_LEFT=$((SECONDS_LEFT - 1))
done
echo ""
cat <<EOF > hello.yaml
apiVersion: v1
kind: Secret
metadata:
  name: registry-secret
type: Opaque
stringData:
  username: admin
  password: Harbor12345
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello
  labels:
    app: hello
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello
  template:
    metadata:
      labels:
        app: hello
    spec:
      containers:
        - name: hello
          image: ReplaceWithHost/library/hello:latest
          ports:
            - containerPort: 8080
      imagePullSecrets:
        - name: registry-secret
      restartPolicy: Always
---
apiVersion: v1
kind: Service
metadata:
  name: hello
spec:
  selector:
    app: hello
  ports:
    - protocol: TCP
      port: 80 # clusterIP port
      targetPort: 8080 # process port
      nodePort: 30080 #external
  type: NodePort
EOF
KUBECONFIG=/etc/rancher/k3s/k3s.yaml \
  sed s/ReplaceWithHost/$(hostname -f \
  | tr '[:upper:]' '[:lower:]')/g hello.yaml \
  | kubectl apply -f - --insecure-skip-tls-verify=true
SECONDS_LEFT=45
while [ $SECONDS_LEFT -gt 0 ]; do
    printf "\rShort pause: %02d" "$SECONDS_LEFT"
    sleep 1
    SECONDS_LEFT=$((SECONDS_LEFT - 1))
done
echo ""
curl -k http://$(hostname -f | tr '[:upper:]' '[:lower:]'):30080/hello