output "aws_instance_dns" {
  description = "DNS public address to access EC2 instance "
  value       = aws_instance.server[*].public_dns
}