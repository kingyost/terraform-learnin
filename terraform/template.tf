#provider config
provider "aws" {
  region = "eu-central-1"
}

#Resource config
resource "aws_instance" "hello-instance" {
  ami           = "ami-0b7fd829e7758b06d"
  instance_type = "t2.micro"
  tags = {
  Name = "hello-reupdated-instance"
  }
}
