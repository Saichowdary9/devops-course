provider "aws" {
  region = var.region
}

# -------------------------
# Security Group - Flask
# -------------------------
resource "aws_security_group" "flask_sg" {
  name = "flask-sg"

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

# -------------------------
# Security Group - Express
# -------------------------
resource "aws_security_group" "express_sg" {
  name = "express-sg"

  ingress {
    from_port   = 3000
    to_port     = 3000
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

# -------------------------
# EC2 - Flask
# -------------------------
resource "aws_instance" "flask" {
 ami = "ami-03f4878755434977f"
  instance_type = "t3.micro"
  key_name      = var.key_name

  security_groups = [aws_security_group.flask_sg.name]

  user_data = file("flask.sh")

  tags = {
    Name = "Flask-Server"
  }
}

# -------------------------
# EC2 - Express
# -------------------------
resource "aws_instance" "express" {
  ami = "ami-03f4878755434977f"
  instance_type = "t3.micro"
  key_name      = var.key_name

  security_groups = [aws_security_group.express_sg.name]

  user_data = file("express.sh")

  tags = {
    Name = "Express-Server"
  }
}