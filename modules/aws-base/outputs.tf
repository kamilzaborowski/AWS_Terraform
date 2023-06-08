output "aws_instance_dns" {
  description = "DNS public address to access EC2 instance "
  value = {
    Servername = aws_instance.server[*].tags.Servername
    DNS        = aws_instance.server[*].public_dns
  }
}

output "aws_lb_dns" {
  description = "DNS for ALB"
  value       = aws_lb.alb.dns_name
}