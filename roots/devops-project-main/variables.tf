variable "greeting" {
  description = "A greeting phrase"
}

variable "iam_roles" {
  type        = map(any)
  description = "Map for iam role creation"
}