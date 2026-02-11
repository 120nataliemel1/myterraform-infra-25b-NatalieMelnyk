Terraform RDS MySQL with CloudWatch Monitoring
Overview

This project provisions an AWS RDS MySQL database using Terraform and integrates CloudWatch alarms to monitor database performance.
The primary focus is to monitor CPU utilization for the Versus application and trigger alerts when thresholds are exceeded.

The infrastructure follows Terraform GitOps best practices, uses custom modules only, and is deployed via CI/CD pipelines.

Architecture Components

RDS MySQL

Configurable engine version, instance class, storage, backups, and networking

CloudWatch Alarm

Monitors RDS CPU utilization

Triggers alerts when CPU usage exceeds defined thresholds

SNS

Sends email notifications when alarms enter ALARM or return to OK

Terraform Modules

Modular, reusable, and environment-agnostic

GitHub Actions

Used to deploy infrastructure consistently across environments

Folder Structure
terraform/
├── dummy-module-1/              
├── dummy-module-2/              
├── rds-mysql/                   # RDS MySQL Terraform module
├── rds-cloudwatch/              # CloudWatch alarms + SNS module
│   ├──main.tf
│   ├──output.tf
│   └──variables.tf
│
├── roots/
│   └── devops-project-main/
│       ├── main.tf
│       ├── variables.tf
│       ├── providers.tf
│       ├── dev.tfvars
│       ├── staging.tfvars
│       └── production.tfvars



RDS MySQL Module

The rds-mysql module creates an RDS MySQL instance with support for:

Custom instance identifier

Storage configuration

Backup retention and backup window

Multi-AZ support

VPC and security group integration

Tagging for cost allocation and governance

The module exposes the RDS instance identifier, which is consumed by the CloudWatch alarm module.

CloudWatch CPU Alarm
Purpose

The CloudWatch alarm monitors CPU utilization for the RDS MySQL instance and helps detect performance degradation early.

Configuration

Metric: CPUUtilization

Namespace: AWS/RDS

Threshold: CPU > 80%

Evaluation Periods: 2 × 5 minutes

Statistic: Average

Missing Data Handling: notBreaching

Behavior

When CPU usage exceeds the threshold, the alarm enters the ALARM state

When CPU usage returns to normal, the alarm transitions back to OK

Notifications are sent for both state changes

SNS Notifications

An SNS topic is created specifically for RDS CPU alerts.

Email subscription is configured for notifications

Subscription requires email confirmation after deployment

SNS topic ARN is used by the CloudWatch alarm for notifications

Environment Support

The project supports multiple environments using .tfvars files:

dev.tfvars

staging.tfvars

production.tfvars

The production environment is the primary focus for CloudWatch alarms, with the ability to scale monitoring to other environments in the future.

Deployment

Terraform is executed via the existing GitHub Actions CI/CD pipeline.

Typical pipeline steps:

terraform init
terraform validate
terraform plan
terraform apply


No external Terraform modules are used.

Testing the CloudWatch Alarm

To verify alarm functionality without stressing the database, the AWS CLI is used.

Force Alarm State
aws cloudwatch set-alarm-state \
  --alarm-name <alarm-name> \
  --state-value ALARM \
  --state-reason "Testing CPU alarm"

Expected Results

Alarm transitions to ALARM

SNS notification email is received

Alarm can later return to OK

This confirms correct alarm behavior and notification delivery.

Acceptance Criteria Coverage

CloudWatch alarm triggers correctly on high CPU usage

Alarm is tied directly to the Versus RDS instance

SNS notifications are delivered successfully

Terraform modules follow best practices

Code is deployed via CI/CD

Documentation clearly explains setup and usage

Notes & Best Practices

Changes are committed frequently to maintain a clear work history

Infrastructure is tested incrementally to avoid bulk troubleshooting

Monitoring modules are designed to be reusable for additional metrics (memory, storage, connections)

Next Improvements (Optional)

Add FreeableMemory and DatabaseConnections alarms

Conditionally enable alarms per environment

Centralize SNS notifications for all RDS metrics

Summary

This project demonstrates real-world DevOps infrastructure work, including:

Infrastructure as Code

Monitoring and alerting

CI/CD integration

Modular Terraform design

Production-ready AWS practices