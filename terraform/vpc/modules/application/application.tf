variable "vpc_id"    {}
variable "subnet_id" {}
variable "Name"      {}

resource "aws_security_group" "allow_http" {
  name = "allow_http"
  description = "Allow HTTP traffic"
  vpc_id = "${var.vpc_id}"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks  = [
      "0.0.0.0/0"
    ]
  }
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks  = [
      "0.0.0.0/0"
    ]
  }
}

resource "aws_instance" "app-server" {
  ami = "ami-0b7fd829e7758b06d"
  instance_type = "t2.micro"
  subnet_id = "${var.subnet_id}"
  vpc_security_group_ids = [
    "${aws_security_group.allow_http.id}"
  ]
  tags = {
    Name = "${var.Name}"
  }
}

output "hostname" {
  value = "${aws_instance.app-server.private_dns}"
}
