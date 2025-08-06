#!/bin/bash
set -e # stop the script if something wrong

echo "Deleting Minikube..."
minikube delete

if minikube status &> /dev/null; then
  echo "Minikube still running after delete!"
  exit 1
else
  echo "Minikube successfully deleted."
fi