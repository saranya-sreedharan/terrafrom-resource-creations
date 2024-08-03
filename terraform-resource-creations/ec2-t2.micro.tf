provider "aws" {
  alias  = "t2_micro"
  region = "us-east-1"
}


# Create a new PEM key pair
resource "aws_key_pair" "u20_key_pair" {
  key_name   = "ec2_u20_pemkey"  # Name of the key pair
  public_key = file("~/.ssh/id_rsa.pub")  # Path to the public key file on your local machine
}

# Define the security group with ingress and egress rules
resource "aws_security_group" "u20ec2_sg" {
  name        = "u20ec2_sg"
  description = "Security group for u20ec2 server"

  # Ingress rules
  ingress {
    from_port   = 80
    to_port     = 80
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
    from_port   = 5000
    to_port     = 5000
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
resource "aws_instance" "u20ec2_server" {
  ami           = "ami-06aa3f7caf3a30282"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.u20_key_pair.key_name  # Associate the instance with the key pair
  vpc_security_group_ids = [aws_security_group.u20ec2_sg.id]  # Associate the instance with the security group
  tags = {
    Name = "u20ec2-server"
  }
}

# Output the entire EC2 instance details in JSON format to a file named ec2.json
resource "null_resource" "output_ec2_details" {
  provisioner "local-exec" {
    command = <<-EOT
      echo '${aws_instance.u20ec2_server}' > ec2.json
    EOT
  }
}

# Output the PEM key content
output "pem_key_content" {
  value = aws_key_pair.u20_key_pair.public_key
}
  

  # Run remote-exec provisioner as a separate resource
resource "null_resource" "run_script" {
  triggers = {
    instance_id = aws_instance.u20ec2_server.id
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ubuntu_script.sh",  # Make the script executable
      "ubuntu_script.sh",           # Execute the script
    ]

    connection {
      type     = "ssh"
      user     = "ubuntu"  
      private_key = file("/path/to/your/private/key.pem")  
      host     = aws_instance.u20ec2_server.public_ip  
    }
  }
}


