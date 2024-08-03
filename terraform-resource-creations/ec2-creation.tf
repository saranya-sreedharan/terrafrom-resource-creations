provider "aws" {
  alias  = "default"
  region = "us-east-1"
}


# Define the security group with ingress and egress rules
resource "aws_security_group" "example_sg" {
  name        = "example_sg"
  description = "Security group for example EC2 instance"

  # Ingress rules
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

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22  # SSH port
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule allowing all traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Define the EC2 instance
resource "aws_instance" "example_instance" {
  ami           = "ami-0cd59ecaf368e5ccf"  # Example AMI ID, replace with your desired AMI
  instance_type = "t2.micro"
  key_name      = "ec2_pemkey.pem"     # Replace with your key pair name
  security_groups = [aws_security_group.example_sg.name]  # Associate the instance with the security group
  tags = {
    Name = "example-instance"
  }
}

# Output the entire EC2 instance details in JSON format to a file named ec2.json
resource "null_resource" "output_ec2_details" {
  provisioner "local-exec" {
    command = <<-EOT
      echo '${aws_instance.u20ec2_server}' > ec2.json
    EOT
  }