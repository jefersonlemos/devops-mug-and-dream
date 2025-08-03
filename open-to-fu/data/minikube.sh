#!/bin/bash
set -e # stop the script if something wrong

STATUS=$(minikube status | grep 'host:' | awk '{print $2}')

if [ "$STATUS" = "Running" ]; then
  echo "Minikube is already running."
else
  echo "Starting Minikube in background..."
  minikube start --driver=docker --alsologtostderr &

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
fi

echo "Setting kubectl context to minikube..."
kubectl config use-context minikube
