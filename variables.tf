variable "vpc_endpoint_id" {
  type        = string
  description = "ID of the VPC endpoint to associate with the subnet."
}

variable "subnet_id" {
  type        = string
  description = "ID of the subnet to associate with the VPC endpoint."
}
