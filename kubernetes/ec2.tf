resource "aws_instance" "cp" {
  depends_on             = [aws_subnet.public_subnets, aws_internet_gateway.gw]
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnets.id
  vpc_security_group_ids = [aws_security_group.cp.id]
  key_name               = data.aws_key_pair.key.key_name
  user_data              = <<-EOF
                              #!/bin/bash
                              sudo apt-get update
                              sudo apt-get install -y apt-transport-https ca-certificates curl
                              curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
                              echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
                              sudo apt-get update
                              sudo apt-get install -y kubelet kubeadm kubectl
                              sudo apt-mark hold kubelet kubeadm kubectl
                              kubeadm init | grep -i "kubeadm join" >> /tmp/output.txt
                              mkdir -p $HOME/.kube
                              sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
                              sudo chown $(id -u):$(id -g) $HOME/.kube/config
                              sudo systemctl enable apache2
                              EOF


  tags = {
    Servername = "Control-Plane"
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
  user_data              = <<-EOF
                              #!/bin/bash
                              sudo apt-get update
                              sudo apt-get install -y apt-transport-https ca-certificates curl
                              curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
                              echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
                              sudo apt-get update
                              sudo apt-get install -y kubelet kubeadm
                              sudo apt-mark hold kubelet kubeadm
                              kubeadm init
                              mkdir -p $HOME/.kube
                              sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
                              sudo chown $(id -u):$(id -g) $HOME/.kube/config
                              scp ubuntu@${aws_instance.cp.private_dns}:/tmp/output.txt /tmp/output.txt
                              bash /tmp/output.txt
                              rm /tmp/output.txt
                              EOF


  tags = {
    Servername = "Worker-Node-${count.index + 1}"
  }
}