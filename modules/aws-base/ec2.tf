resource "aws_instance" "server" {
  depends_on             = [aws_subnet.subnets, aws_internet_gateway.gw]
  ami                    = data.aws_ami.ubuntu.id
  count                  = length(var.availability_zones)
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnets[count.index].id
  vpc_security_group_ids = [aws_security_group.allow.id]
  key_name               = data.aws_key_pair.key.key_name
  user_data              = <<-EOF
                              #!/bin/bash
                              sudo apt update
                              sudo apt install -y httpd
                              echo "<H1>Witaj na $(hostname -f)</H1> >> /var/www/html/index.html"
                              echo "<H2> I'm in subnet ${var.cidr_blocks[count.index]}}</H2> >> /var/www/html/index.html"
                              echo "<H2>File created at: $(date)</H2> >> /var/www/html/index.html"
                              sudo systemctl enable httpd
                              sudo systemctl start httpd
                              EOF

  tags = {
    Servername = "Server-${count.index + 1}"
  }
}