output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_arn" {
  value = aws_vpc.main.arn
}

output "public_subnets_id" {
    value = aws_subnet.public_subnets[*].id
}

output "public_subnets_arn" {
    value = aws_subnet.public_subnets[*].arn
}

output "private_subnet_id" {
    value = aws_subnet.private_subnets[*].id
}

output "private_subnet_arn" {
    value = aws_subnet.private_subnets[*].arn
}
