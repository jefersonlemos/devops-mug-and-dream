#!/bin/bash
set -e # stop the script if something wrong

if ! command -v minikube &> /dev/null; then
  echo "Minikube is not installed."
  exit 1
fi

if ! command -v kubectl &> /dev/null; then
  echo "Kubectl is not installed."
  exit 1
fi

if ! command -v helm &> /dev/null; then
  echo "Helm is not installed."
  exit 1
fi
