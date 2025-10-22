output "subnets_ids" {
  description = "Subnet ID created on AWS"
  value       = aws_subnet.subnet[*].id
}

