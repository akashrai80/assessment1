provider "aws" {
  region = var.region
}

# Filter out local zones, which are not currently supported 
# with managed node groups
data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "daffodil-vpc-1"

  cidr = "10.0.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = ["10.0.1.0/24"]
  public_subnets  = ["10.0.4.0/24"]

#   enable_nat_gateway   = true
#   single_nat_gateway   = true
  enable_dns_hostnames = true
}

resource "aws_security_group" "this" {
  name        = "assessment-1"
  description = "sg for assessment 1"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "allow 3000"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    description      = "allow 8080"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    description      = "allow ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_instance" "this" {
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = module.vpc.public_subnets.0
  key_name = "assessment_key"
  associate_public_ip_address = true
  security_groups = [ aws_security_group.this.id ]
  tags = {
    Name = "assessment-1"
  }
  provisioner "remote-exec" {
    inline = [ 
        "docker run -itd -p3000:3000 image2:latest",
        "docker run -itd -p8080:8080 image1:latest"
     ]
     connection {
       type = "ssh"
       user = "ubuntu"
       private_key = file("./assessment_key.pem")
       host = self.public_ip
     }
    
  }
}