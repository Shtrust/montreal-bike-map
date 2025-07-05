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
    set -xe

    exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

    dnf update -y
    dnf install -y docker git

    mkdir -p /usr/local/libexec/docker/cli-plugins
    curl -SL https://github.com/docker/compose/releases/download/v2.24.6/docker-compose-linux-x86_64 \
      -o /usr/local/libexec/docker/cli-plugins/docker-compose
    chmod +x /usr/local/libexec/docker/cli-plugins/docker-compose

    

    systemctl enable docker
    systemctl start docker
    usermod -aG docker ec2-user

    cd /home/ec2-user
    rm -rf montreal-bike-map
    git clone https://github.com/Shtrust/montreal-bike-map.git
    chown -R ec2-user:ec2-user /home/ec2-user/montreal-bike-map

    cd montreal-bike-map
    docker --version
    docker compose version

    docker compose build --no-cache
    docker compose up -d
  EOF

   user_data_replace_on_change = true

  vpc_security_group_ids = [aws_security_group.allow_http.id]

  tags = {
    Name = "MontrealBikeMap"
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http-"
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
