output "aws_instance_dns" {
  description = "DNS public address to access EC2 instance "
  value = {
    CP-Servername     = aws_instance.cp.tags.Servername
    CP-DNS            = aws_instance.cp.public_dns
    Worker-Servername = aws_instance.worker_nodes[*].tags.Servername
    Worker-DNS        = aws_instance.worker_nodes[*].public_dns
    Worker-local-IP   = aws_instance.worker_nodes[*].private_ip
  }
}