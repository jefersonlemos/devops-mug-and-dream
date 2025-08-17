#!/bin/bash
set -e # stop the script if something wrong

minikube start --driver=docker --memory=8192 --cpus=6 --insecure-registry="registry.kube-system.svc.cluster.local:80"
minikube addons enable registry && minikube addons enable registry registry-aliases
kubectl config use-context minikube
