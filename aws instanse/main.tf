#my terraform
#build web server
#buil by jenyatopol
#simple hello-world
provider "aws" {
    
    region = "us-east-1"
  
}
resource "aws_instance" "my_web_server_ubu" {
    count                  = 0
    ami                    = "ami-01cc34ab2709337aa"             #amazon-linux server          
    instance_type          = "t2.micro"
    key_name               =  "terraform_key_pait"
    vpc_security_group_ids = [aws_security_group.my_security_group.id]
    user_data = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
echo "<html><body bdcolor=black><center><h1><p><font color=red>Hello-World from server1</h1></center></body></html>" > /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
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

 }

  egress{ 
    
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  
}
   
