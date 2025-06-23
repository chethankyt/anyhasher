resource "aws_instance" "anyhasher_server" {
  ami           = "ami-0f3f13f145e66a0a3"
  instance_type = "t2.micro"
  key_name      = "anyhasher"

  tags = {
    Name = var.instance_name,
    Purpose = "Learning CI/CD Pipeline"
  }
}

variable "instance_name" {
  description = "Terraform EC2 instance name"
}

output "ec2_public_ip" {
  value = aws_instance.anyhasher_server.public_ip
}

