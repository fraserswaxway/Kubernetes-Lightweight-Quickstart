#!/bin/bash
mkdir -p /root/usr/local/share/ca-certificates/$(hostname -f | tr '[:upper:]' '[:lower:]') \
  && curl -s -k https://$(hostname -f | tr '[:upper:]' '[:lower:]')/api/v2.0/systeminfo/getcert \
  > /root/usr/local/share/ca-certificates/$(hostname -f | tr '[:upper:]' '[:lower:]')/ca.crt