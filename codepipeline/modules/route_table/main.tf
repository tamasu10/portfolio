######################################################################################
# Routetable
######################################################################################

resource "aws_route_table" "this" {
  vpc_id = var.vpc_id

  dynamic "route" {
    for_each = var.route

    content {
      cidr_block         = route.value["cidr_block"]
      instance_id        = route.value["instance_id"]
      transit_gateway_id = route.value["transit_gateway_id"]
      gateway_id         = route.value["gateway_id"]
      nat_gateway_id     = route.value["nat_gateway_id"]
    }
  }

  tags = {
    Name = var.route_table_name
  }
}

resource "aws_route_table_association" "this" {
  count          = length(var.subnet_ids)
  subnet_id      = var.subnet_ids[count.index]
  route_table_id = aws_route_table.this.id
}

