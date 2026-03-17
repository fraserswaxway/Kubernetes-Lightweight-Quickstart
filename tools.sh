#!/bin/bash
systemctl stop xagt
systemctl disable xagt
apt update -y
apt upgrade -y
apt autoremove -y
apt install curl git podman -y
mkdir -p /opt/cni/bin
wget https://github.com$(curl -s https://github.com/containernetworking/plugins/releases \
  | grep download | grep amd64 | grep tgz\" | sed -n 's/.*href=\"\(\S*\)\".*/\1/p')
tar -xvf cni-plugins-linux-amd64-*.tgz -C /opt/cni/bin/
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash -