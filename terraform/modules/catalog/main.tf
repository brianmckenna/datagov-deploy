data "aws_ami" "ubuntu_trusty" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "catalog" {
  name        = "${var.prefix}-catalog"
  description = "Allow web traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "catalog" {
  count         = "${var.count_instances}"
  ami           = "${data.aws_ami.ubuntu_trusty.id}"
  instance_type = "t2.micro"
  associate_public_ip_address = "true"
  key_name = "${var.admin_key_name}"
  vpc_security_group_ids = ["${aws_security_group.catalog.id}", "${var.security_groups}"]
  subnet_id = "${var.subnet_id}"

  tags {
    Terraform = "true"
    Environment = "test"
    Owner = "${var.owner}"
  }
}
