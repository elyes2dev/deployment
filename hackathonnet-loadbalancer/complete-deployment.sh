#!/bin/bash
set -e

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

# Create PersistentVolume and PersistentVolumeClaim for MySQL
echo "Creating PersistentVolume for MySQL..."
kubectl apply -f mysql-pv.yaml

echo "Creating PersistentVolumeClaim for MySQL..."
kubectl apply -f mysql-pvc.yaml

# Deploy MySQL
echo "Deploying MySQL database..."
kubectl apply -f mysql-deploy.yaml
kubectl apply -f mysql-service.yaml
echo "Waiting for MySQL deployment to be ready..."
kubectl rollout status deployment/mysql -n hackathonnet

# Deploy backend
echo "Deploying backend application..."
kubectl apply -f backend-deployment.yaml
kubectl apply -f back-service.yaml
echo "Waiting for backend deployment to be ready..."
kubectl rollout status deployment/backend -n hackathonnet

# Deploy frontend deployment
echo "Deploying frontend application..."
kubectl apply -f front-deploy.yaml

# Deploy frontend service as LoadBalancer
echo "Creating LoadBalancer service for frontend..."
kubectl apply -f front-service.yaml
echo "Waiting for frontend deployment to be ready..."
kubectl rollout status deployment/hackathonnet-frontend -n hackathonnet

# Check status
echo "Checking deployment status..."
kubectl get pods -n hackathonnet
kubectl get services -n hackathonnet

echo "Setup complete. Once the LoadBalancer gets an external IP, you can access your application."
echo "To check the LoadBalancer IP, run: kubectl get service hackathonnet-frontend-service -n hackathonnet"
