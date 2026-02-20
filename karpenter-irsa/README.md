# Karpenter Terraform Child Module

## Overview

This Terraform child module provisions the IAM resources required to run
[Karpenter](https://karpenter.sh/) on an Amazon EKS cluster.

It implements:

- IAM Role for the Karpenter controller (IRSA)
- IAM Policy with least-privilege permissions
- IAM Role for EC2 nodes launched by Karpenter
- IAM Instance Profile for Karpenter-managed nodes

The module follows AWS best practices for:
- IAM Roles for Service Accounts (IRSA)
- Scoped `iam:PassRole`
- Tag-restricted instance profile creation
- Least-privilege EC2 access

---

## What This Module Creates

### 1. Karpenter Controller IAM Role (IRSA)

Creates an IAM role assumed by a Kubernetes ServiceAccount via OIDC.

Trust policy allows:

- `sts:AssumeRoleWithWebIdentity`
- Only the specified namespace + ServiceAccount
- Only the provided OIDC provider
- Audience restricted to `sts.amazonaws.com`

This ensures only the Karpenter controller pod can assume the role.

---

### 2. Karpenter Controller IAM Policy

Grants permissions required for:

- Launching EC2 instances
- Managing Launch Templates
- Creating and tagging instance profiles
- Describing subnets, security groups, and cluster metadata
- Terminating EC2 instances (restricted to Karpenter-managed nodes)

Termination is restricted using: **ec2:ResourceTag/karpenter.sh/nodepool**
This prevents deletion of non-Karpenter instances.

`iam:PassRole` is scoped to the dedicated Karpenter node role.

---

### 3. Karpenter Node IAM Role

Creates an EC2 role assumed by instances provisioned by Karpenter.

Attached AWS-managed policies:

- AmazonEKSWorkerNodePolicy
- AmazonEKS_CNI_Policy
- AmazonEC2ContainerRegistryPullOnly
- AmazonSSMManagedInstanceCore

These allow nodes to:

- Join the cluster
- Configure networking (CNI)
- Pull images from ECR
- Be managed via SSM

---

### 4. Instance Profile

Creates: **aws_iam_instance_profile.karpenter_node_instance_profile**

This profile is attached to EC2 instances launched by Karpenter.

---

## File Structure
karpenter/
├── Karpenter-irsa.tf # Controller IRSA role + permissions
├── node-iam.tf # EC2 node IAM role + instance profile
├── variables.tf # Input variables
└── outputs.tf # Exposed role ARNs and profile name

---

## Separation of responsibilities:

- `Karpenter-irsa.tf` → Controller identity
- `node-iam.tf` → Node identity