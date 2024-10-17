#!bin/bash
kubectl exec -it -n vault vault-0 -- sh -c "
vault operator init
"