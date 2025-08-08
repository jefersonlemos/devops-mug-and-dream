#!/bin/bash
set -e

IP=$(minikube ip)
echo "{\"ip\": \"${IP}\"}"