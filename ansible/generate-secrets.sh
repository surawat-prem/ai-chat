#!bin/bash
mkdir -p .secrets

touch .secrets/kops-secrets.yaml

aws iam create-access-key --user-name kops | awk '{print "AWS_ACCESS_KEY_ID: "$2; print "AWS_SECRET_ACCESS_KEY: "$4}' > .secrets/kops-secrets.yaml

echo "S3_NAME: $(aws s3api list-buckets --query "Buckets[].Name")" >> .secrets/kops-secrets.yaml