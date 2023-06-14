variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "cidr_blocks" {
  type    = list(string)
  default = ["20.0.1.0/24", "20.0.2.0/24", "20.0.3.0/24"]
}