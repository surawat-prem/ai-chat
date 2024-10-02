### REPOSITORY STRUCTURE
- cloud-deployment 
    - (IaC for AWS resources)
- ansible 
    - (playbooks for setting up controller vm and creating kubernetes cluster with 'kops')
- ops-deployment
    - (kubernetes deployment manifests for operational services)
- argocd-config 
    - (configurations for ArgoCD)
- app-deployment 
    - (kubernetes deployment manifests for application microservices)
- microservices 
    - (microservices fe + be)

---

### CLOUD-DEPLOYMENT
#### pre-requirements:
-   github repo
    -   setup github app integration with terraform
-   terraform cloud ( login with github for repo access )
    -   setup organization 'name' and workspace name 'network' with
        -   VCS branch 'non-prod'
        -   Working directory at '/cloud-deployment/network-workspace'
        -   Watch change pattern at '/cloud-deployment/network-workspace/*'
    -   setup workspace name 'controller' with
        -   VCS branch 'non-prod'
        -   Working directory at '/cloud-deployment/controller-workspace'
        -   Watch change pattern at '/cloud-deployment/controller-workspace/*'
        -   Configure 'network' workspace enable 'Remote state sharing' with workspace 'controller'
        
-   AWS account
    -   create IAM user for terraform
        -   get AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION=ap-southeast-1 and setup in terraform cloud as terraform-variables 'sensitive' (*for all workspace)

#### requirements
-   terraform cloud variables:
    -   PERSONAL_PUBLIC_KEY ( your ssh public key for controller vm ssh) - workspace 'controller'

#### steps:
-   workspace 'network'
    -   create unique name for 
    -   trigger 'network' workspace plan and apply
-   workspace 'controller'
    -   input your public ip to cidr_ipv4 variable for 'aws_vpc_sg_ingress_rules' for ssh access (ansible)
    -   trigger 'controller' workspace plan and apply

#### post-setups:
-   Install openvpn access server in controller machine (to run Kops, act as vpn server for accessing private Kuebrnetes cluster)
    -   Create Openvpn account ref(https://openvpn.net/product-select)
    -   SSH into controller machine and install openvpn-as
    -   Create corresponding settings
        -   activate free tier subscription
        -   assign network address to be your controller-vpc cidr not overlapping controller subnet
        -   enable routing to your controller-vpc and workload-vpc
        -   change openvpn password, and create user for use later

---
### Ansible
pre-requirements:
-   has private hosted zone in route53 matching your cluster name and add value for ansible/group_vars/all/vars.yaml "PRIVATE_DNS_NAME"
-   run ansible/ansible_playbooks/generate-secrets.sh
-   provide necessary values for cluster in ansible/group_vars/all/vars.
-   provide public ip for your controller machine in ./inventory file
-   install ansible in your machine ref(https://docs.ansible.com/ansible/latest/installation_guide/index.html)
    
#### steps
-   Run playbook to setup necessary packages
```bash
    #!bin/bash
    ansible-playbook setup.yaml \
    ansible-playbook create-cluster.yaml
```
-   When done SSH into controller machine and run command below to obtain you kubeconfig then store for use later
```bash
    #!bin/bash
    kops export kubeconfig {{ your_cluster_name}} --admin
```
-   Test connection to kubernetes cluster by using openvpn connection and kubeconffig obtained

### GITHUB - DOCKERHUB
#### pre-requirements:
-   Dockerhub
    -   setup dockerhub public repo for chat-fe/chat-backend/chat-server
-   Github
    -   create PAT (read,write) for your account and provide in github/actions/repository-secrets as
        -   DOCKER_USERNAME
        -   DOCKER_PASSWORD
    -   Enable github action repo read and write

### OPS-DEPLOYMENT
#### pre-requirement:
-   Manual installation