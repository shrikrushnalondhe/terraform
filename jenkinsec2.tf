provider "aws" {
  region     = "ap-south-1"
 }
resource "aws_security_group" "ec2-sgnew" {
  name = "ec2-sgnew"
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
   from_port   = 8080
   to_port     = 8080
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

resource "aws_instance" "dockerec2" {
  ami = "ami-0a23ccb2cdd9286bb"
  instance_type = "t2.micro"
  key_name= "aws_key"
  security_groups = [aws_security_group.ec2-sgnew.name]
  tags = {
    Name = "dockerec2"
  }
  connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "jenkins"
      private_key = file("/home/jenkins/keys/aws_key")
      timeout     = "4m"
   }
}
resource "aws_key_pair" "deployer" {
  key_name   = "aws_key1"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9pKGwpIYn4jiBZGQfs9T7lGUHOvjurO5nU02y4jXEExQ7G+c3OwmNQN/d4F8OtTYtKl5PcIRWEvHRPQ3cUT3KooFKCZIpoSmxLLhFTFv96wi1KFjMMs25D6YR1mBj2XVXdDJe0DvFL/2xcHf+4U2zUrm6m6AMyfmu2U58Ls/67uLG3Y+2mGcuBBv//oC70oQM3thYlW74xw5nNUC91LKZnuUg6ZOMGPc3AeLnZhJz0SBBJxhe04xy5iWHk+CPNgU5Dgt6kFLmWV+XrBAP5k+AfXb7ipgpwYiFi/Oq8f46h95TVHTJZydAjswoz3GdS2lcd7R26AtSybnECn5/OOBf jenkins@ip-172-31-23-199.ec2.internal"
}
output "instance_ips" {
  value = aws_instance.dockerec2.public_ip
}
