resource "null_resource" "example" {
  provisioner "local-exec" {
    command = "echo ${local.greeting_message}"
  }
}

output "output_name" {
  value = local.greeting_message
}
