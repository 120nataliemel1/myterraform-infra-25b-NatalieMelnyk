# ExternalDNS IRSA (Route53 – Least Privilege)

This module creates **IAM Role for Service Accounts (IRSA)** that allows **external-dns running in Amazon EKS** to safely manage DNS records in **specific Route53 hosted zones**. 

No AWS access keys.  
No node-level permissions.  
Only one Kubernetes ServiceAccount is allowed to do this.

---

## How it works (high level)

1. Terraform reads the EKS cluster’s OIDC provider
2. An IAM policy is created with permission to manage DNS records only in specific hosted zones
3. An IAM role is created that:
   - trusts the EKS OIDC provider
   - can only be assumed by one Kubernetes ServiceAccount
4. The policy is attached to the role
5. Kubernetes uses this role via IRSA, not static credentials

---

**Security notes (permissions explained)**
- Uses IRSA instead of AWS access keys
- IAM permissions are least-privilege
- DNS access is restricted to specific hosted zones
- Only one ServiceAccount can assume the role
- Trust policy is tied to the cluster’s OIDC issuer

---

## Module responsibilities (child module)
The external-dns-irsa module:
- Creates an IAM policy for Route 53 access
- Limits DNS access to only the hosted zones you pass in
- Creates an IAM role with a trust policy for EKS OIDC
- Restricts role assumption to:
  - one namespace
  - one ServiceAccount
- Attaches the policy to the role

## Root module responsibilities
**The root module:**
- Reads the EKS cluster details
- Fetches the OIDC provider ARN and URL
- Passes environment-specific values into the module:
  - environment name (dev, staging, prod)
  - hosted zone IDs
  - namespace and service account name

## Inputs

| Variable | Description |
|--------|------------|
| `environment` | Environment name (dev, stage, prod) |
| `hosted_zone_ids` | Route 53 hosted zone IDs external-dns can manage |
| `cluster_name` | EKS cluster name |
| `external_dns_namespace` | Kubernetes namespace where external-dns runs |
| `external_dns_sa_name` | ServiceAccount name used by external-dns |

---

## Typical workflow
1. Deploy EKS cluster
2. Apply this Terraform module
3. Install external-dns with a ServiceAccount annotated with the IAM role ARN
4. external-dns automatically creates and updates Route 53 records

---

## Why this matters
This setup is:
- production-safe
- CI/CD-friendly
- audit-friendly
- reusable across environments