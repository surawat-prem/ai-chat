#!bin/bash
helm install -n argocd --atomic --create-namespace argocd ./ -f aichat-values.yaml
kubectl apply -n argocd -f .secrets
kubectl apply -n argocd -f ./cluster-app.yaml