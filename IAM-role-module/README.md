# IAM-role Terraform Module

This repository contains Terraform code to **define and manage AWS IAM roles and policies** in a reusable and modular way.

---

## Module Overview

- The **child module** builds IAM roles, creates policies, and attaches them to roles.  
- Policies are stored in **JSON format** inside `IAM-role-module/policies`.  
- Roles can be assumed by either an **AWS account/role/user** or an **AWS service**.

---

## Guidelines

1. **Creating Policies**  
   - Add new JSON policy files in the `IAM-role-module/policies` directory.  
   - When using a policy in your module, reference the **file name only** (e.g., `"DeveloperProdAccessRole.json"`).  

2. **Principal Type & Principal**  
   - `principal_type` defines **who can assume the role**:  
     - `"AWS"` → IAM user, role, or AWS account.  
     - `"Service"` → AWS service like EC2, Lambda, etc.  
   - `principal` is the **ARN or identifier** corresponding to the principal type.  

3. **Environment Tagging**  
   - Use the `environment` variable to differentiate roles across environments (`dev`, `prod`, etc.).  

---

## Example Usage in `main.tf`

module "developer_iam_role" {
  source         = "../../IAM-role-module"
  environment    = var.environment
  principal_type = "AWS"
  principal      = var.trusted_parent_account_id
  role_name      = "Developer${var.environment}AccessRole-ubuntu25b"
  policy_json    = var.DeveloperAccessRolePolicy
}

## Notes

- **Policy JSON:**  
  `policy_json` should match the filename of the policy stored in `IAM-role-module/policies`.

- **Principal alignment:**  
  `principal_type` and `principal` must match. Examples:  
  - **AWS account:**  
    ```hcl
    principal_type = "AWS"
    principal      = "arn:aws:iam::123456789012:root"
    ```  
  - **EC2 service:**  
    ```hcl
    principal_type = "Service"
    principal      = "ec2.amazonaws.com"
    ```

- **Multiple accounts:**  
  You can pass a **list of ARNs** to trust multiple accounts and dynamically generate principals in your module.

- **Environment tagging:**  
  Always use `environment` to tag roles consistently for dev, staging, and prod environments.

- **Security best practices:**  
  Prefer trusting **specific roles or users** instead of the account root whenever possible.
