#my terraform
#build web server
#buil by jenyatopol
#ubuntu inctance with open for all security group
provider "aws" {
    
    region = "us-east-1"
  
}
resource "aws_instance" "my_web_server_ubu" {
    count                  = 0
    ami                    = "ami-09e67e426f25ce0d7"             #ubuntu server          
    instance_type          = "t3.micro"
    key_name               =  "terraform_key_pait"
    vpc_security_group_ids = [aws_security_group.my_security_group.id]
    user_data = <<EOF
#!/bin/bash
sudo -y update
EOF
}
resource "aws_security_group" "my_security_group" {
  name        = "my_security_group"
  description = "Allow my_first_security_group"
  
ingress {
    
      description      = "TLS from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
   ingress {
    description = "http from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }    
   ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

 }

  egress{ 
    
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  
}
