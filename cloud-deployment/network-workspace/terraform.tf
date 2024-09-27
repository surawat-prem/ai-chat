terraform {
	required_version = "~> 1.9"
	required_providers {
        aws = {
          source = "hashicorp/aws"
          version = "5.66.0"
        }
    }
  backend "remote" {
    organization = "chat-system-infra"
    workspaces {
      name = "network"
    }
  }
}