output "association_id" {
  description = "The ID of the VPC Endpoint Subnet Association."
  value       = try(aws_vpc_endpoint_subnet_association.this[0].id, "")
}

output "enabled" {
  description = "Whether the module is enabled."
  value       = local.enabled
}
