resource "aws_vpc_endpoint_subnet_association" "this" {
  count = local.enabled ? 1 : 0

  vpc_endpoint_id = var.vpc_endpoint_id
  subnet_id       = var.subnet_id
}
