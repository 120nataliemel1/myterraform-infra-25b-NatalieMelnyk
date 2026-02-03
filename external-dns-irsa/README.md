# ExternalDNS IRSA (Route53 – Least Privilege)

This module creates the IAM setup required for **ExternalDNS** to manage DNS records in **specific Route53 hosted zones** using **IRSA**.

No AWS access keys.  
No node-level permissions.  
Only one Kubernetes ServiceAccount is allowed to do this.

---

## What this does

1. Creates an IAM policy  
   → allows ExternalDNS to change DNS records only in specific hosted zones.

2. Creates an IAM role
   → trusted by the EKS OIDC provider (IRSA)

3. Attaches the policy to the role  
   → the role gets the DNS permissions

4. Outputs the role ARN  
   → used in the Kubernetes ServiceAccount annotation

---

## Why IRSA

IRSA allows AWS to trust a Kubernetes ServiceAccount via OIDC.

This means:
- Permissions are assigned at the pod level, not node
- Only the ExternalDNS pod can use this role
- Safer and easier to audit

---

## Permissions explained

- ExternalDNS can **create, update, and delete DNS records**
- Only in the hosted zones listed in `hosted_zone_ids`
- It can **list hosted zones** so AWS knows where to apply changes


This follows the principle of **least privilege**.

---

## Inputs

| Variable | Description |
|--------|------------|
| `hosted_zone_ids` | Route53 hosted zone IDs ExternalDNS is allowed to manage |
| `oidc_arn` | OIDC provider ARN for the EKS cluster |
| `oidc_provider_url` | OIDC provider URL for the EKS cluster |
| `namespace` | Kubernetes namespace where ExternalDNS runs |
| `service_account` | Kubernetes ServiceAccount used by ExternalDNS |

---

## Outputs

| Output | Description |
|------|------------|
| `external_dns_role_arn` | IAM role ARN assumed by ExternalDNS |
| `external_dns_policy_arn` | IAM policy ARN attached to the role |