#!/bin/bash
set -e
# chmod +x deploy.sh
# This script sets up a Kubernetes cluster with MetalLB and deploys a frontend application.
# Create namespace first
echo "Creating hackathonnet namespace..."
kubectl apply -f namespaces.yaml

# Install MetalLB
echo "Installing MetalLB..."
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.10/config/manifests/metallb-native.yaml

# Wait for MetalLB pods to be ready
echo "Waiting for MetalLB pods to become ready..."
kubectl wait --namespace metallb-system \
  --for=condition=ready pod \
  --selector=app=metallb \
  --timeout=90s

# Apply MetalLB configuration
echo "Applying MetalLB configuration..."
kubectl apply -f metallb-config.yaml

# Deploy frontend deployment
echo "Deploying frontend application..."
kubectl apply -f front-deploy.yaml

# Deploy frontend service as LoadBalancer
echo "Creating LoadBalancer service for frontend..."
kubectl apply -f front-service.yaml

# Check status
echo "Checking deployment status..."
kubectl get pods -n hackathonnet
kubectl get services -n hackathonnet

echo "Setup complete. Once the LoadBalancer gets an external IP, you can access your application."
echo "To check the LoadBalancer IP, run: kubectl get service hackathonnet-frontend-service -n hackathonnet"