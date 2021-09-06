resource "aws_security_group" "ec2-sg" {
  name = "ec2-sg"
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

  egress {
   from_port   = 0
   to_port     = 0
   protocol    = "all"
   cidr_blocks = ["0.0.0.0/0"]
  }

  tags ={
    type ="terraform-test-security-group"
  }
}

resource "aws_instance" "web1" {
  ami = "ami-04db49c0fb2215364"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.ec2-sg.name]
  tags = {
    Name = "web1"
  }
}
