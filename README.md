# terraform-eks

## Overview

This Terraform project facilitates the deployment of an AWS Elastic Kubernetes Service (EKS) cluster. The infrastructure is defined as code, allowing for easy provisioning and management of the Kubernetes cluster on AWS.

## Project structure

```
.
├── eks-cluster
│   ├── eks-cluster.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── terragrunt.hcl
│   ├── variables.tf
│   ├── vars_dev.tfvars
│   ├── vars_prod.tfvars
│   └── vpc.tf
├── eks-config
│   ├── config_mongodb.tf
│   ├── ecr.tf
│   ├── main.tf
│   ├── namespaces.tf
│   ├── terragrunt.hcl
│   └── variables.tf
├── modules
│   └── ecr
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── README.md
└── terragrunt.hcl
```

## Prerequisites

> Install `terraform` and `terragrunt` CLI tools

-`terraform` managed with tfenv
https://github.com/tfutils/tfenv

-`terragrunt` managed with tgswitch
https://github.com/warrensbox/tgswitch

Install/use the terraform and terragrunt correct version with the next command

> Execute the commands in the root project folder in order to read the config files `.terraform-version` and `.terragrunt-version`

terraform
```bash
tfenv use
```

terragrunt
```bash
tgswitch
```

## APPLY STEPS

1. Export the next env vars to set up the terraform s3 backend and AWS creds
```sh
export AWS_ACCESS_KEY_ID=<AWS_ACCESS_KEY_ID>
export AWS_SECRET_ACCESS_KEY=<AWS_SECRET_ACCESS_KEY>
export AWS_DEFAULT_REGION='us-east-1'
export TF_VAR_env_name='dev'
export TF_VAR_backend_s3_bucket=<states-bucket>
export TF_VAR_backend_s3_region=<states-bucket-region>
```


2. Apply **(First time)** following EKS blueprints pattern https://aws-ia.github.io/terraform-aws-eks-blueprints/getting-started/#deploy

```sh
cd eks-cluster
terragrunt init
terragrunt apply -target="module.vpc" -auto-approve
terragrunt apply -target="module.eks" -auto-approve
terragrunt apply -auto-approve
cd ../eks-config
terragrunt apply -auto-approve
```

> This is only the first time

Then you can execute normally in the root folder

```sh
terragrunt run-all apply
```

This will run both components `eks cluster` and `eks-config` at the same time
https://terragrunt.gruntwork.io/docs/features/execute-terraform-commands-on-multiple-modules-at-once/#the-run-all-command

## DESTROY

Steps to Destroy all the resources

```
helm list -A
```

> remove example API releases first


Then remove resources
```bash
cd eks-config
terragrunt destroy -auto-approve
cd eks-cluster
terragrunt destroy -target=module.eks_blueprints_addons -auto-approve
terragrunt destroy -target=module.eks -auto-approve
terragrunt destroy -auto-approve
```