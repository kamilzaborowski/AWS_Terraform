data "local_file" "pvt" {
    filename = "~/.ssh/do_rsa"
}
data "local_file" "pub" {
    filename = "~/.ssh/do_rsa.pub"
}