# Versus App — RDS MySQL Database on AWS with Terraform & GitHub Actions

## Overview

This project provisions a MySQL RDS database on AWS for the **Versus App** using Terraform, deployed entirely through GitHub Actions following GitOps principles. It includes a multi-environment setup (dev, staging, production), a dedicated CloudWatch alarm module for CPU monitoring, and credentials management via AWS Secrets Manager.

No off-the-shelf Terraform modules are used — all modules are custom-built.

---

## Architecture

```
┌──────────────────────────────────────────────────────────┐
│                        AWS Account                       │
│                                                          │
│  ┌─────────────────── EKS VPC ────────────────────────┐  │
│  │                                                    │  │
│  │   ┌──────────────┐        ┌──────────────────────┐ │  │
│  │   │  EKS Cluster │        │    Private Subnets   │ │  │
│  │   │  (Versus App)│───────▶│  ┌──────────────────┐│ │  │
│  │   └──────────────┘        │  │   RDS MySQL 8.4  ││ │  │
│  │                           │  │   (t4g.micro)    ││ │  │
│  │                           │  └──────────────────┘│ │  │
│  │                           └──────────────────────┘ │  │
│  └────────────────────────────────────────────────────┘  │
│                                                          │
│  ┌──────────────────┐   ┌─────────────────────────────┐  │
│  │  Secrets Manager │   │  CloudWatch Alarm (CPU>80%) │  │
│  │  (DB Credentials)│   └─────────────────────────────┘  │
│  └──────────────────┘                                    │
└──────────────────────────────────────────────────────────┘
```

**Key components:**

- **RDS MySQL 8.4** deployed in private subnets of the existing EKS VPC
- **Dedicated security group** controlling ingress to the database
- **AWS Secrets Manager** storing database credentials
- **CloudWatch Alarm** monitoring CPU utilization (threshold: 80%)
- **GitHub Actions** executing all Terraform plan/apply operations

---

## Repository Structure

```
.

├── modules/
│   ├── rds-mysql/
│   │   ├── main.tf            # RDS instance, sg ,security group
│   │   ├── variables.tf       # Module input variables
│   │   └──  outputs.tf        # Module outputs(endpoint,port,etc.)  
│   │   └── README.md        
│   └── rds-cloudwatch/
│       ├── main.tf            # CloudWatch alarm definition
│       ├── variables.tf       # Alarm thresholds, SNS topic ARN, etc.
│       └── outputs.tf         # Alarm ARN output
│ 
├── dev.tfvars                 # Development variable overrides
├── staging.tfvars             # Staging variable overrides
├── production.tfvars          # Production variable overrides
├── main.tf                    # Root module — calls child modules
├── variables.tf               # Root-level variable declarations
├── providers.tf               # AWS provider & backend configuration
└── README.md
```

---

## Terraform Modules

### `modules/rds` — RDS MySQL Child Module

This custom module provisions the following resources:

| Resource | Purpose |
|---|---|
| `aws_db_instance` | MySQL 8.4 RDS instance (t4g.micro) |
| `aws_db_subnet_group` | Places RDS in private subnets of the EKS VPC |
| `aws_security_group` | Dedicated SG allowing MySQL traffic (port 3306) from the EKS cluster |
| `aws_secretsmanager_secret` | Stores DB master username and password |
| `aws_secretsmanager_secret_version` | Populates the secret value |

**Key configurable variables per environment:**

| Variable | Dev | Staging | Production |
|---|---|---|---|
| `instance_class` | db.t4g.micro | db.t4g.micro | db.t4g.micro (or larger) |
| `multi_az` | `false` | `true` | `true` |
| `backup_retention_period` | 1 | 1 | 30 |
| `deletion_protection` | `false` | `true` | `true` |
| `storage_encrypted` | `true` | `true` | `true` |
| `allocated_storage` | 20 | 20 | 100 |

### `modules/cloudwatch` — CloudWatch Alarm Child Module

| Resource | Purpose |
|---|---|
| `aws_cloudwatch_metric_alarm` | Triggers when RDS CPU exceeds 80% for 5 minutes |
| `aws_sns_topic`  | Notification target for alarm actions |
| `aws_sns_topic_subscription`  | Email for alerts |

---

## Multi-Environment & Branching Strategy

| Branch | Target Environment | tfvars File |
|---|---|---|
| `feature/*` | Development | `/dev.tfvars` |
| `main` | Production (temporarily deployed to dev) | `/dev.tfvars` (temporary) |

---

## GitHub Actions Workflow

The CI/CD pipeline (`.github/workflows/terraform-deploy.yml`) runs all Terraform operations. No local Terraform execution is permitted.

**Pipeline steps:**

1. **Checkout** — Clone the repository
2. **Configure AWS Credentials** — Assume `GitHubActionsTerraformIAMrole` via OIDC using the `IAM_ROLE` secret from the `dev` GitHub environment
3. **Terraform Init** — Initialize with remote S3 backend
4. **Terraform Validate** — Syntax and configuration checks
5. **Terraform Plan** — Generate execution plan using the appropriate `.tfvars` file
6. **Terraform Apply** — Apply changes (on push to `main` or manual trigger)

**AWS Integration (pre-configured by 312 team):**

- IAM Role: `GitHubActionsTerraformIAMrole` with `AdministratorAccess`
- GitHub Environment: `dev`
- GitHub Secret: `IAM_ROLE` (stores the IAM role ARN)

---

## Deployment Instructions

### Prerequisites

- AWS account with the EKS VPC already provisioned
- GitHub repository with the `dev` environment and `IAM_ROLE` secret configured
- S3 bucket and DynamoDB table for Terraform remote state

### Deploy via GitHub Actions

1. Create a feature branch:
   ```bash
   git checkout -b feature/rds
   ```

2. Make your changes, commit, and push:
   ```bash
   git add .
   git commit -m "feat: add RDS MySQL module"
   git push origin feature/rds-setup
   ```

3. The GitHub Actions workflow will automatically run `terraform plan`.

4. Open a Pull Request to `main`, obtain 3 approvals, and merge.

5. On merge to `main`, the workflow runs `terraform apply` to provision the infrastructure.

---

## Verifying the Database

Once the RDS instance is running, verify connectivity from inside the EKS cluster:

```bash
# 1. Enter Running Application Pod
kubectl get pods -n versus-app
kubectl exec -it <backend-pod-name> -n versus-app -- /bin/sh

# 2.Install MySQL Client Inside Pod
apk add mysql-client

# 3. Connect to the RDS instance
mysql -h versus-db-dev.cd0tsmgxxcdk.us-east-1.rds.amazonaws.com -u admin -p
```

---

## CloudWatch CPU Alarm
### Purpose

The CloudWatch alarm monitors CPU utilization for the RDS MySQL instance and helps detect performance degradation early.

### Configuration

- Metric: CPUUtilization

- Namespace: AWS/RDS

- Threshold: CPU > 80%

- Evaluation Periods: 2 × 5 minutes

- Statistic: Average

- Missing Data Handling: notBreaching

### Behavior

- When CPU usage exceeds the threshold, the alarm enters the ALARM state

- When CPU usage returns to normal, the alarm transitions back to OK

- Notifications are sent for both state changes

### SNS Notifications

- An SNS topic is created specifically for RDS CPU alerts.

- Email subscription is configured for notifications

- Subscription requires email confirmation after deployment

- SNS topic ARN is used by the CloudWatch alarm for notifications

### Environment Support

The project supports multiple environments using .tfvars files:

- dev.tfvars

- staging.tfvars

- production.tfvars

The production environment is the primary focus for CloudWatch alarms, with the ability to scale monitoring to other environments in the future.

### Deployment

Terraform is executed via the existing GitHub Actions CI/CD pipeline.

#### Typical pipeline steps:

```
terraform init
terraform validate
terraform plan
terraform apply
```


## Testing the CloudWatch Alarm

To verify alarm functionality without stressing the database, the AWS CLI is used.

Force Alarm State
```python
aws cloudwatch set-alarm-state \
  --alarm-name versus-dev-rds-cpu-high \
  --state-value ALARM \
  --state-reason "Testing CPU alarm"
```

 ### Expected Results

- Alarm transitions to ALARM

- SNS notification email is received

- Alarm can later return to OK

This confirms correct alarm behavior and notification delivery.

---

## Security Best Practices

- RDS is deployed in **private subnets** only — no public accessibility
- A **dedicated security group** restricts access to port 3306 from the EKS cluster CIDR/security group only
- Database credentials are stored in **AWS Secrets Manager**, not in Terraform state or code
- **Storage encryption** is enabled by default
- **Deletion protection** is enabled in staging and production
- **Automated backups** are configured with environment-specific retention periods
- No off-the-shelf Terraform modules are used — all infrastructure code is custom

---

