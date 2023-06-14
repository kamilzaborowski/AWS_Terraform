resource "aws_instance" "cp" {
  depends_on             = [aws_subnet.public_subnets, aws_internet_gateway.gw]
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnets.id
  vpc_security_group_ids = [aws_security_group.cp.id]
  key_name               = data.aws_key_pair.key.key_name
  user_data              = templatefile("user_data_cp.tpl")


  tags = {
    Servername = "Control-Plane"
  }

  provisioner "local_exec" {
    
  }
}

resource "aws_instance" "worker_nodes" {
  depends_on             = [aws_subnet.private_subnets, aws_internet_gateway.gw, aws_instance.cp]
  count                  = length(var.availability_zones) - 1
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnets[count.index].id
  vpc_security_group_ids = [aws_security_group.worker.id]
  key_name               = data.aws_key_pair.key.key_name
  user_data              = templatefile("user_data_worker.tpl")


  tags = {
    Servername = "Worker-Node-${count.index + 1}"
  }
}