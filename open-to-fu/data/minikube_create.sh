#!/bin/bash
set -e # stop the script if something wrong

echo "Starting Minikube in background..."
minikube start --driver=docker --memory=8192 --cpus=6 --insecure-registry="registry.kube-system.svc.cluster.local:80,192.168.49.0/24"
minikube addons enable registry
kubectl config use-context minikube
