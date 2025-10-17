output "subnet_id" {
  description = "Subnet ID created on AWS"
  value       = aws_subnet.subnet_default.id
}

output "subnet_id_provider_1" {
  description = "Subnet ID created on AWS for provider 1"
  value       = aws_subnet.subnet_unitedstates.id
}

output "subnet_id_provider_2" {
  description = "Subnet ID created on AWS for provider 2"
  value       = aws_subnet.subnet_europe.id
}