data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "id"
    values = ["ami-06a1f46caddb5669e"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_key_pair" "key" {
  key_name = "terraform"
}