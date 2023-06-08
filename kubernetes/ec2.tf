resource "aws_instance" "cp" {
  depends_on             = [aws_subnet.public_subnets, aws_internet_gateway.gw]
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = t2.micro
  subnet_id              = aws_subnet.public_subnets[count.index].id
  vpc_security_group_ids = [aws_security_group.allow.id]
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
                              kubeadm init
                              mkdir -p $HOME/.kube
                              sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
                              sudo chown $(id -u):$(id -g) $HOME/.kube/config
                              sudo systemctl enable apache2
                              EOF
                              

  tags = {
    Servername = "Control-Plane"
  }
}