resource "aws_eip" "nat_eip" {
  vpc = true
  tags = {
    Name = var.eip_name
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = var.subnet_id
  tags = {
    Name = var.nat_name
  }
}