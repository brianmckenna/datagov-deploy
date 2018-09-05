provider "aws" {
  region = "us-west-1"
}

resource "aws_key_pair" "admin" {
  key_name   = "${var.prefix}-admin-key"
  public_key = "${var.ssh_public_key}"
}
