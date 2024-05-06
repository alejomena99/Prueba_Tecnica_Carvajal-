data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main" {
 cidr_block = var.vpc_cidrs
 
 tags = {
   Name = var.tags.Terraform == "true" ? "${var.tags.Environment}-vpc-tf-${var.name}" : "${var.tags.Environment}-vpc-${var.name}"
 }
}

resource "aws_subnet" "public_subnets" {
 count             = length(var.public_subnets)
 vpc_id            = aws_vpc.main.id
 cidr_block        = element(var.public_subnets, count.index)
 availability_zone = coalesce(element(var.availability_zones, count.index), data.aws_availability_zones.available.names[0])
 
 tags = {
   Name = var.tags.Terraform == "true" ? "${var.tags.Environment}-public-subnet-tf-${var.name}-${count.index + 1}" : "${var.tags.Environment}-public-subnet-${var.name}-${count.index + 1}"
 }

}
 
resource "aws_subnet" "private_subnets" {
 count             = length(var.private_subnets)
 vpc_id            = aws_vpc.main.id
 cidr_block        = element(var.private_subnets, count.index)
 availability_zone = coalesce(element(var.availability_zones, count.index), data.aws_availability_zones.available.names[0])
 
 tags = {
   Name = var.tags.Terraform == "true" ? "${var.tags.Environment}-private-subnet-tf-${var.name}-${count.index + 1}" : "${var.tags.Environment}-private-subnet-${var.name}-${count.index + 1}"
 }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ec2_instance" {
  count         = length(aws_subnet.public_subnets)
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnets[count.index].id
  user_data     = <<EOF
        #!/bin/bash

        sudo su
        apt update
        apt upgrade -y
        apt install -y apache2
        systemctl start apache2
        systemctl enable apache2
        echo "Hello World from $(hostname -f)" > /var/www/html/index.html
        EOF
  tags = {
    Name = var.tags.Terraform == "true" ? "${var.tags.Environment}-ec2-tf-${var.name}-${count.index + 1}" : "${var.tags.Environment}-ec2-${var.name}-${count.index + 1}"
  }
}

resource "aws_security_group" "security_group" {
 name        = var.tags.Terraform == "true" ? "${var.tags.Environment}-security-group-${var.name}" : "${var.tags.Environment}-security-group-${var.name}"
 description = "Allow HTTPS to web server"
 vpc_id      = aws_vpc.main.id

ingress {
   description = "HTTPS ingress"
   from_port   = 80
   to_port     = 80
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }

 tags = {
   Name = var.tags.Terraform == "true" ? "${var.tags.Environment}-security-group-ec2-${var.name}" : "${var.tags.Environment}-security-group-ec2-${var.name}"
 }
}

resource "aws_internet_gateway" "gw" {
 vpc_id = aws_vpc.main.id
 
 tags = {
   Name = var.tags.Terraform == "true" ? "${var.tags.Environment}-gw-tf-${var.name}" : "${var.tags.Environment}-gw-${var.name}"
 }
}

resource "aws_eip" "elastic_ip" {
  domain   = "vpc"

  tags = {
    Name = var.tags.Terraform == "true" ? "${var.tags.Environment}-elastic-ip-tf-${var.name}" : "${var.tags.Environment}-elastic-ip-${var.name}"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name = var.tags.Terraform == "true" ? "${var.tags.Environment}-nat-tf-${var.name}" : "${var.tags.Environment}-nat-${var.name}"
  }
}

resource "aws_route_table" "public_rt" {
 vpc_id = aws_vpc.main.id
 
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.gw.id
 }
 
 tags = {
   Name = var.tags.Terraform == "true" ? "${var.tags.Environment}-public-routetb-tf-${var.name}" : "${var.tags.Environment}-public-routetb-${var.name}"
 }
}

resource "aws_route_table" "private_rt" {
 vpc_id = aws_vpc.main.id
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_nat_gateway.nat.id
 }
 tags = {
   Name = var.tags.Terraform == "true" ? "${var.tags.Environment}-private-routetb-tf-${var.name}" : "${var.tags.Environment}-private-routetb-${var.name}"
 }
}

resource "aws_route_table_association" "public_subnet_asso" {
 count = length(var.public_subnets)
 subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
 route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_subnet_asso" {
 count = length(var.private_subnets)
 subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
 route_table_id = aws_route_table.private_rt.id
}

resource "aws_network_interface_sg_attachment" "security_group_attachment" {
  count                 = length(aws_instance.ec2_instance[*].network_interface)
  security_group_id     = aws_security_group.security_group.id
  network_interface_id  = aws_instance.ec2_instance[count.index].primary_network_interface_id
}

resource "aws_lb_target_group" "target_group" {
  name     = var.tags.Terraform == "true" ? "${var.tags.Environment}-target-group-${var.name}" : "${var.tags.Environment}-target-group-${var.name}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_target_group_attachment" "target_group_attachment" {
  count            = length(aws_instance.ec2_instance[*].id)
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.ec2_instance[count.index].id
  port             = 80
}
