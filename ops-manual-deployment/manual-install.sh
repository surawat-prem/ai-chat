#!bin/bash
echo "Initializing ArgoCD"
kubectl create ns argocd
kubectl apply -f ./argo-cd/argocd-cm.yaml
helm install --atomic -n argocd --atomic argocd ./argo-cd -f ./argo-cd/aichat-values.yaml
kubectl apply -n argocd -f ./argo-cd/.secrets
kubectl apply -n argocd -f ./argo-cd/cluster-app.yaml

echo "Creating vault secrets"
kubectl create ns vault
kubectl apply -f ./vault/.secrets

echo "Creating certmanager secrets"
kubectl apply -f ./vault/.secrets