                                          How to use terraform


1. Make sure that you installed terraform and configured terraform correctly in your machine.

terraform version
![alt text](image.png)

2. Create a file with extension(.tf) eg:ec2-t2.micro.tf

![alt text](image-1.png)

3. Write the terraform file to create t2.micro ubuntu machine 20.04

![alt text](image-2.png)

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "test_server" {
  ami           = "ami-06aa3f7caf3a30282"
  instance_type = "t2.micro"
  key_name      = "ec2_pemkey.pem"
  vpc_security_group_ids = ["launch-wizard-47"]
  tags = {
    Name = "test-server"
  }
}



3. Terraform init for the initialization
![alt text](image-3.png)


We will get a successful message in console

![alt text](image-4.png)

4. terraform validate


![alt text](image-5.png)


Make sure that you created a user. And add security credentials. (Access keys)



Command line interface (example)
aws configure
 Access key : AKIA3LACPLE72C5YCNH2
 Secret access key : zoXDDofoByw4Xd7i5dT7auc8UkEmnnaSLx3ZZivk

![alt text](image-7.png)




5. Once it is configured then run terraform plan

![alt text](image-6.png)

6. Give  terraform apply (give yes for the confirmation)
![alt text](image-8.png)










