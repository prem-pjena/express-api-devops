# Create a VPC
resource "aws_vpc" "express_api_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "express_api_vpc"
  }
}

# Create a subnet
resource "aws_subnet" "main_subnet" {
  vpc_id                  = aws_vpc.express_api_vpc.id  # Updated to reference the new VPC
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"  # Modify based on your region
  map_public_ip_on_launch = true
  tags = {
    Name = "main_subnet"
  }
}

# Security Group with HTTP and SSH rules (Reference the new VPC created above)
resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = aws_vpc.express_api_vpc.id  # Reference the new VPC created
  
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
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "express_api" {
  ami                    = "ami-00a929b66ed6e0de6"  # Ensure this is a valid AMI for your region
  instance_type          = "t2.micro"  # Free-tier eligible instance
  key_name               = "my-key"  # Replace with your SSH key name
  
  # Use security group ID
  security_groups    = [aws_security_group.allow_http.id]  # Reference the security group by its ID
  
  subnet_id              = aws_subnet.main_subnet.id  # Attach EC2 instance to the subnet
  associate_public_ip_address = true
  tags = {
    Name = "express-api-instance"
  }

  # User data script to install Docker and Docker Compose
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              service docker start
              usermod -aG docker ec2-user
              curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose
              cd /home/ec2-user
              git clone https://github.com/your-username/express-api-devops.git
              cd express-api-devops
              docker-compose up -d
              EOF

}
