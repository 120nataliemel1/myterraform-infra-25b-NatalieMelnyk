greeting = "Hi"

iam_roles = {
  DeveloperDevAccessRole-ubuntu25b = {
    principal_type = "AWS"
    principal      = "arn:aws:iam::879500880845:root"
    policy_file    = "DevopsDevAccessRole.json"
  }

  DevopsDevAccessRole-ubuntu25b = {
    principal_type = "AWS"
    principal      = "arn:aws:iam::879500880845:root"
    policy_file    = "DevopsDevAccessRole.json"
  }
}