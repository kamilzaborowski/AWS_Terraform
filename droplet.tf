resource "digitalocean_droplet" "jenkins-1" {
    image = "ubuntu-20-04-x64"
    name = "jenkins-1"
    region = "fra1"
    size = "s-1vcpu-1gb"
    ssh_keys = [
      data.digitalocean_ssh_key.terraform.id
    ]
}
provisioner "remote-exec" {
  inline = ["sudo apt update", "sudo apt install -y openjdk-8-jdk openjdk-8-jre docker"]

  connection {
    host = self.ipv4_address
    type = "ssh"
    user = "root"
    private_key = var.pvt_key
  }
}
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${self.ipv4_address},' --private-key ${var.pvt_key} -e 'pub_key=${var.pub_key}' apache-install.yml"
  }