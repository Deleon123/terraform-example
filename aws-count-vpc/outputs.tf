output "subnet_id_1" {
  description = "Subnet ID created on AWS"
  value       = aws_subnet.subnet[0].id
}

output "subnet_id_2" {
  description = "Subnet ID created on AWS"
  value       = aws_subnet.subnet[1].id
}

output "subnet_id_3" {
  description = "Subnet ID created on AWS"
  value       = aws_subnet.subnet[2].id
}

