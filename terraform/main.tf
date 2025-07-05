provider "aws" {
  region = "us-east-2"
}

# EC2 instance
resource "aws_instance" "bike_map_server" {
  ami           = "ami-0c803b171269e2d72" # ✅ Use a real Amazon Linux 2023 AMI for us-east-2
  instance_type = "t3.micro"
  key_name      = "my-bikemap-ke" # ✅ Make sure your key pair exists in this region

  user_data = <<-EOF
              #!/bin/bash
              exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

              # Update OS
              dnf update -y

              # Install Docker
              dnf install docker -y
              systemctl enable docker
              systemctl start docker
              usermod -a -G docker ec2-user

              # Install Docker Compose
              curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-\\$(uname -s)-\\$(uname -m)" -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose

              # Install Git
              dnf install git -y

              # Clone your project
              cd /home/ec2-user
              git clone https://github.com/Shtrust/montreal-bike-map.git

              cd montreal-bike-map
              docker-compose up -d
            EOF

  vpc_security_group_ids = [aws_security_group.allow_http.id]

  tags = {
    Name = "MontrealBikeMap"
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP and custom ports"

  ingress {
    from_port   = 80
    to_port     = 80
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
    from_port   = 22
    to_port     = 22
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
