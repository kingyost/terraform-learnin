provider "aws" {
  region              = "eu-central-1"
}

resource "aws_vpc" "my_vpc" {
  cidr_block          = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id              = "${aws_vpc.my_vpc.id}"
  cidr_block          = "10.0.1.0/24"
}

resource "aws_instance" "master-instance" {
  ami                 = "ami-0b7fd829e7758b06d"
  instance_type       = "t2.micro"
  subnet_id           = "${aws_subnet.public.id}"
  tags                = {
    Name              = "Master"
  }
}

resource "aws_instance" "maid-instance" {
  ami                 = "ami-0b7fd829e7758b06d"
  instance_type       = "t2.micro"
  subnet_id           = "${aws_subnet.public.id}"
  tags                = {
    master_hostename  = "${aws_instance.master-instance.private_dns}"
    Name              = "maid"
  }
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

module "mighty_trousers" {
  source             = "./modules/application"
  vpc_id             = "${aws_vpc.my_vpc.id}"
  subnet_id          = "${aws_subnet.public.id}"
  Name               = "MightyTrousers"
}

module "crazy_foods" {
  source             = "./modules/application"
  vpc_id             = "${aws_vpc.my_vpc.id}"
  subnet_id          = "${aws_subnet.public.id}"
  Name               = "CrazyFoods ${module.mighty_trousers.hostname}" 

}
