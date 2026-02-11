Versus App – RDS MySQL Infrastructure (Terraform + GitHub Actions)
Overview

This project provisions a MySQL RDS database on AWS for the Versus App using Terraform, following GitOps principles and multi-environment design.

All infrastructure changes are executed exclusively via GitHub Actions, with no local Terraform execution, simulating a real production DevOps workflow.

The solution includes:

A custom Terraform module for RDS MySQL

Secure credential management via AWS Secrets Manager

Private networking inside an existing EKS VPC

Environment-aware configuration (dev / staging / prod)

CloudWatch alarms for production-grade monitoring

End-to-end verification from inside a Kubernetes pod


Architecture Overview

High-level flow:

GitHub (feature/*, main)
        |
        v
GitHub Actions (OIDC → AWS IAM Role)
        |
        v
Terraform Apply (Remote State in S3)
        |
        v
AWS Resources:
  - RDS MySQL (Private Subnets)
  - Secrets Manager (DB Credentials)
  - Security Group (MySQL Access)
  - CloudWatch Alarm (CPU > 80%)


The RDS instance is deployed privately inside the permanent EKS VPC and accessed only from internal workloads (e.g., Kubernetes pods).

🔁 GitOps Workflow
Branch Strategy
Branch	Environment	Notes
feature/*	Development	Active development & testing
main	Production (temporarily dev)	Used until prod account is available

Since staging and production AWS accounts are not yet available, the main branch currently deploys into the dev account using dev.tfvars.

Pull Request Rules

All changes must go through a Pull Request

3 approvals required:

1 Project Manager

2 Peers / Teammates

No direct commits to main

GitHub Actions automatically runs Terraform on merge

This enforces reviewed, auditable infrastructure changes.

Repository Structure
terraform-infra/
├── modules/
│   ├── rds-mysql/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   └── cloudwatch-alarms/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── root/devops-project-main
   └── dev.tfvars
   └── main.tf
   └── production.tfvars
   └── variables.tf
   └── providers.tf
   └──staging.tfvars


Terraform Modules
RDS MySQL Module

Location: modules/rds-mysql

This module provisions:

MySQL RDS instance (MySQL 8.4)

DB subnet group (private subnets only)

Dedicated security group

Secure credentials in AWS Secrets Manager

Key Features
Feature	Implementation
Engine	MySQL 8.4
Instance Type	db.t4g.micro
Public Access	Disabled
Subnets	Private only
Credentials	AWS Secrets Manager
Multi-AZ	Configurable per environment
Backups	Enabled & configurable
Environment Behavior
Environment	Multi-AZ
dev	❌ Disabled
staging	Optional
prod	✅ Enabled


Verification & Testing
Database Connectivity Test

Access the database from inside Kubernetes:

kubectl exec -it deploy/versus-app -- bash


Install MySQL client:

yum install -y mysql


Connect to RDS:

mysql -h <rds-endpoint> -u versus_admin -p


Verify:

SHOW DATABASES;
SELECT VERSION();
