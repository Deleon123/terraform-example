output "vpc_id_provider_default" {
  description = "VPC ID created on AWS for provider default"
  value       = aws_vpc.default.id
}

output "vpc_id_provider_1" {
  description = "VPC ID created on AWS for provider 1"
  value       = aws_vpc.vpc_provider_1.id
}

output "vpc_id_provider_2" {
  description = "VPC ID created on AWS for provider 2"
  value       = aws_vpc.vpc_provider_2.id
}