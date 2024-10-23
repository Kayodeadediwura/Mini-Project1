terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-2"
}


resource "aws_security_group" "my-mini-project" {


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


resource "aws_instance" "frontend_node_1" {
  ami                    = var.frontend_node_1_ami
  instance_type          = var.frontend_node_1_instance_type
  key_name               = var.frontend_node_1_key_name
  subnet_id              = var.frontend_node_1_subnet_id
  user_data              = file("./frontend_install.sh")
  vpc_security_group_ids = [aws_security_group.my-mini-project.id]

  tags = {
    Name = "frontend_node_1"
  }
}

resource "aws_instance" "frontend_node_2" {
  ami                    = var.frontend_node_2_ami
  instance_type          = var.frontend_node_2_instance_type
  key_name               = var.frontend_node_2_key_name
  subnet_id              = var.frontend_node_2_subnet_id
  user_data              = file("./frontend_install.sh")
  vpc_security_group_ids = [aws_security_group.my-mini-project.id]

  tags = {
    Name = "frontend_node_2"
  }
}

resource "aws_security_group" "mini-project" {

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "backend_1" {
  ami                    = var.backend_1_ami
  instance_type          = var.backend_1_instance_type
  key_name               = var.backend_1_key_name
  subnet_id              = var.backend_1_subnet_id
  user_data              = file("./backend_install.sh")
  vpc_security_group_ids = [aws_security_group.mini-project.id]

  tags = {
    Name = "backend_1"
  }
}

resource "aws_instance" "backend_2" {
  ami                    = var.backend_2_ami
  instance_type          = var.backend_2_instance_type
  key_name               = var.backend_2_key_name
  subnet_id              = var.backend_2_subnet_id
  user_data              = file("./backend_install.sh")
  vpc_security_group_ids = [aws_security_group.mini-project.id]

  tags = {
    Name = "backend_2"
  }
}

resource "aws_security_group" "sg_database" {


  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "mysql_database" {
  ami                    = var.mysql_database_ami
  instance_type          = var.mysql_database_instance_type
  key_name               = var.mysql_database_key_name
  subnet_id              = var.mysql_database_subnet_id
  user_data              = file("./database_install.sh")
  vpc_security_group_ids = [aws_security_group.sg_database.id]

  tags = {
    Name = "mysql_database"
  }
}

