#!/bin/bash

echo "Configuring microk8s..."

microk8s enable dns ingress rbac metrics-server prometheus storage
microk8s config > ~/.kube/config