#!bin/bash
# Prepare secret files
echo "---Secret file generation started---"
echo "Preparing .secrets directory and creating empty kops-secrets.yaml file"
mkdir -p .secrets
touch .secrets/kops-secrets.yaml
echo "DONE: Preparing .secrets directory and creating empty kops-secrets.yaml file"

# Create access-key for user 'kops'
echo "Creating access-key for user 'kops'"
aws iam create-access-key --user-name kops | awk '{print "AWS_ACCESS_KEY_ID: "$2; print "AWS_SECRET_ACCESS_KEY: "$4}' > .secrets/kops-secrets.yaml
echo "DONE: Creating access-key for user 'kops'"

# Get s3 domain name
echo "Getting s3 domain name"
echo "S3_NAME: $(aws s3api list-buckets --query "Buckets[].Name")" >> .secrets/kops-secrets.yaml
echo "DONE: Getting s3 domain name"

# Get vpc id for kops cluster
echo "Getting vpc id for kops cluster"
VPC_ID=$(aws ec2 describe-vpcs --filters Name=tag:Name,Values=workload --query 'Vpcs[0].VpcId')
echo "VPC_ID: $VPC_ID" >> .secrets/kops-secrets.yaml
echo "DONE: Getting vpc id for kops cluster"

# Get subnet ids for kops cluster
echo "Getting subnet ids for kops cluster"
VPC_ID=$(aws ec2 describe-vpcs --filters Name=tag:Name,Values=workload --query 'Vpcs[0].VpcId')
QUERY_SUBNET_IDS=$(aws ec2 describe-subnets --filters Name=vpc-id,Values=$VPC_ID --output json)
SUBNET_IDS=$(echo "$QUERY_SUBNET_IDS" | jq -c -r '.Subnets[].SubnetId' | paste -sd, -)
echo "SUBNET_IDS: $SUBNET_IDS" >> .secrets/kops-secrets.yaml
echo "DONE: Getting subnet ids for kops cluster"
echo "---Secret file generation completed---"