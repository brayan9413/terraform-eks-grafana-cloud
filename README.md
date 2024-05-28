# terraform-eks-grafana-cloud

## Overview

This Terraform project facilitates the deployment of an AWS Elastic Kubernetes Service (EKS) cluster. The infrastructure is defined as code, allowing for easy provisioning and management of the Kubernetes cluster on AWS.

**Grafana Cloud Integration**

Grafana k8s monitoring is implemented by using A Helm chart for gathering, scraping, and forwarding Kubernetes telemetry data to a Grafana Stack `eks-config/config-grafana-cloud.tf`

An example for custom agent configuration was added here: `eks-config/templates/grafana-alloy-config.yaml`

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
|   └── templates
│       ├── grafana-alloy-config.yaml
│   ├── config_mongodb.tf
│   ├── config-grafana-cloud.tf
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

The terraform infrastructure was created with the following key features:

- Terraform best practices: the terraform state is stored remotely on s3 and a dynamoDB table was created for state locking.

- Multiple terraform backend environments: the infrastructure was created with dynamic terraform backend generation based on the environment variables

```
TF_VAR_backend_s3_bucket
TF_VAR_backend_s3_region
```
*This is perfect for AWS landing zones with multiple AWS environments so you define different GitHub/Gitlab environments with AWS keys for each account.*

- Dynamic `.tfvars` for each environment: By setting the environment variable `TF_VAR_env_name` to different values such as dev, qa, or prod, Terragrunt will automatically select the corresponding .tfvars file based on the naming convention `(vars_<env_name>.tfvars)`. 

For example, setting `TF_VAR_env_name=dev` will make Terragrunt use the `vars_dev.tfvars` file if it exists. This simplifies the management and configurations of the environment-specific variable

this Terragrunt config is located here: ./terragrunt.hcl

- Terraform and Terragrunt version management: for maintaining consistency and compatibility within the project, the files .terraform-version and .terragrunt-version were added to set the versions, using tools like tfenv and tgswitch We can change between multiple projects reducing the risk of version conflicts or inconsistencies.

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

Then you have to create an `s3 bucket` and `DynamoDB table` for state-locking

```bash
aws dynamodb create-table \
         --region ap-south-1 \
         --table-name terraform-lock \
         --attribute-definitions AttributeName=LockID,AttributeType=S \
         --key-schema AttributeName=LockID,KeyType=HASH \
         --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1
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
export TF_VAR_dynamodb_table_state_locking=<DynamoDB-table-name>
# Grafana alloy
export TF_VAR_externalservices_prometheus_basicauth_password=<grafana-alloy-token>
export TF_VAR_externalservices_loki_basicauth_password=<grafana-alloy-token>
export TF_VAR_externalservices_tempo_basicauth_password=<grafana-alloy-token>
```

`grafana-alloy-token`

> An Access Policy token is required for Grafana Alloy to send metrics and logs to Grafana Cloud.
https://grafana.com/docs/grafana-cloud/account-management/authentication-and-permissions/access-policies/

You can create a new token on Grafana cloud > Kubernetes > Configuration > Cluster configuration


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