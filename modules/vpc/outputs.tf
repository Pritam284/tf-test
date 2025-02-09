output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_arn" {
  value = aws_vpc.this.arn
}

output "nat_gw_ip" {
  value = aws_eip.nat_ip.public_ip
}