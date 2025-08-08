#!/bin/bash
set -e # stop the script if something wrong

# awk: text processing tool
# '{print $2}': to print the second field

STATUS=$(minikube status | grep 'host:' | awk '{print $2}')

echo "Starting Minikube in background..."
minikube start --driver=docker --memory=8192 --cpus=6

while true; do
  sleep 5
  STATUS=$(minikube status | grep 'host:' | awk '{print $2}')
  CONTEXT_EXISTS=$(kubectl config get-contexts -o name | grep -w minikube || true)
  if [ "$STATUS" = "Running" ] && [ "$CONTEXT_EXISTS" = "minikube" ]; then
    echo "Minikube started and context exists."
    break
  else
    echo "Waiting for Minikube and kubeconfig context..."
  fi
done

echo "Setting kubectl context to minikube..."
kubectl config use-context minikube

echo "Checking communication with Kubernetes cluster..."
for i in {1..10}; do
  if kubectl get nodes &> /dev/null; then
    echo "Cluster is ready to receive kubectl commands."
    break
  else
    echo "Waiting for Kubernetes API to become responsive... ($i/10)"
    sleep 3
  fi

  if [ "$i" -eq 10 ]; then
    echo "Error: Unable to communicate with the Kubernetes cluster." >&2
    exit 1
  fi
done
