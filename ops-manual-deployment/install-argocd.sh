#!bin/bash
helm install -n argocd --atomic --create-namespace argocd ./argo-cd -f ./argo-cd/aichat-values.yaml
kubectl apply -n argocd -f ./argo-cd/.secrets
kubectl apply -n argocd -f ./argo-cd/cluster-app.yaml