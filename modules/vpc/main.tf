data "aws_availability_zones" "available" {}

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags = merge(
    var.tags
  )
}

resource "aws_subnet" "public_subnet" {
  for_each                = { for ids, subnet in var.public_subnets : ids => subnet }
  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  map_public_ip_on_launch = true

  availability_zone = element(data.aws_availability_zones.available.names, tonumber(each.key))
}

resource "aws_subnet" "private_subnet" {
  for_each   = { for ids, subnet in var.private_subnets : ids => subnet }
  vpc_id     = aws_vpc.this.id
  cidr_block = each.value

  availability_zone = element(data.aws_availability_zones.available.names, tonumber(each.key))
}


# Creating Internet Gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
}

# EIP for NAT GW
resource "aws_eip" "nat_ip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.public_subnet[0].id
}

resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route_table_association" "private" {
  for_each       = { for ids, subnet in var.private_subnets : ids => subnet }
  route_table_id = aws_route_table.private_rtb.id
  subnet_id      = aws_subnet.public_subnet[each.key].id
}

resource "aws_route" "public_igw" {
  route_table_id         = aws_vpc.this.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "private_ngw" {
  route_table_id         = aws_route_table.private_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.ngw.id
}



