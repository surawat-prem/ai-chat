Repository structure
|-> cloud-deployment (IaC for AWS resources)
|-> ansible (runbooks for setting up OpenVpn, ArgoCD??)
|
|-> microservices (microservices fe + be)
|
|-> argocd-config (configurations for ArgoCD)
|-> app-deployment (kubernetes deployment manifests for application microservices)
|-> ops-deployment (kubernetes deployment manifests for operational services)

---

**cloud-deployment**
pre-requirements:
    github repo
        -   setup github app integration with terraform
    terraform cloud ( login with github for repo access )
        -   setup organization 'name' and workspace name 'network' with
            -   VCS branch 'non-prod'
            -   Working directory at '/cloud-deployment/network-workspace'
            -   Watch change pattern at '/cloud-deployment/network-workspace/*'
        -   setup workspace name 'controller' with
            -   VCS branch 'non-prod'
            -   Working directory at '/cloud-deployment/controller-workspace'
            -   Watch change pattern at '/cloud-deployment/controller-workspace/*'
            -   Configure 'network' workspace enable 'Remote state sharing' with workspace 'controller'
        
    AWS account
        -   create IAM user for terraform
            -   get AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION=ap-southeast-1 and setup in terraform cloud as terraform-variables 'sensitive' (*for all workspace)

requirements:
    terraform cloud variables:
        -   PERSONAL_PUBLIC_KEY ( your ssh public key for controller vm ssh) - workspace 'controller'

steps:
    workspace 'network'
        -   create unique name for 
        -   trigger 'network' workspace plan and apply
    workspace 'controller'
        -   input your public ip to cidr_ipv4 variable for 'aws_vpc_sg_ingress_rules' for ssh access (ansible)
        -   trigger 'controller' workspace plan and apply

**ansible**
pre-requirements:
    -   has hosted zone in route53 and add value for ansible/group_vars/all/vars.yaml "DNS_ZONE"
    -   run ansible/ansible_playbooks/generate-secrets.sh
    
steps
    -   