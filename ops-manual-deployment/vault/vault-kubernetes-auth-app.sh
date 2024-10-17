export VAULT_SECRETS_OPERATOR_NAMESPACE=non-prod
export VAULT_SECRETS_OPERATOR_NAME=vault-secrets-operator-non-prod
kubectl exec -it -n vault vault-0 -- sh -c "
vault login $VAULT_ROOT_TOKEN;
vault secrets enable -path=kvv2/$VAULT_SECRETS_OPERATOR_NAMESPACE -version=2 kv
vault policy write $VAULT_SECRETS_OPERATOR_NAME - <<EOF
path "kvv2/data/non-prod/*" {
  capabilities = ["read"]
}
EOF
"
export VAULT_SECRET_NAME=$(kubectl get secret $VAULT_SECRETS_OPERATOR_NAME -o jsonpath="{.metadata.name}" -n $VAULT_SECRETS_OPERATOR_NAMESPACE)
export SA_JWT_TOKEN=$(kubectl get secret $VAULT_SECRET_NAME -o jsonpath="{.data.token}" -n $VAULT_SECRETS_OPERATOR_NAMESPACE | base64 --decode)
export SA_CA_CRT=$(kubectl get secret $VAULT_SECRET_NAME -o jsonpath="{.data.ca\.crt}" -n $VAULT_SECRETS_OPERATOR_NAMESPACE | base64 --decode | sed 's/ /\/g')
export K8S_HOST="https://kubernetes.default.svc.cluster.local"

# Verify the environment variables
env | grep -E 'VAULT_SECRETS_OPERATOR_NAMESPACE|VAULT_SECRET_NAME|SA_JWT_TOKEN|SA_CA_CRT|K8S_HOST'

kubectl exec -it -n vault vault-0 -- sh -c "
vault login $VAULT_ROOT_TOKEN;
vault auth enable kubernetes;
vault write auth/kubernetes/config \
  token_reviewer_jwt="$SA_JWT_TOKEN" \
  kubernetes_host="$K8S_HOST" \
  kubernetes_ca_cert="$SA_CA_CRT";
vault write auth/kubernetes/role/$VAULT_SECRETS_OPERATOR_NAME \
  bound_service_account_names="$VAULT_SECRETS_OPERATOR_NAME" \
  bound_service_account_namespaces="$VAULT_SECRETS_OPERATOR_NAMESPACE" \
  policies="$VAULT_SECRETS_OPERATOR_NAME" \
  ttl=24h;
"