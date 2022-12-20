# creating the (alb) load balancer.
resource "aws_security_group" "sg-apache" {
  name        = "allow_app"
  description = "Allow load balancer"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "from vpc"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  ingress {
    description = "from vpc"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.allow_lb.id]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "allow lb_sg "
  }
}





resource "aws_instance" "myapache1" {
  ami           = "ami-0cca134ec43cf708f"
  instance_type = "t2.micro"
  key_name = aws_key_pair.key.id
  security_groups = [aws_security_group.sg-apache.id]
  subnet_id = aws_subnet.private[0].id
  user_data = <<EOF
    #!/bin/bash
    yum update -y
    yum install httpd -y
    systemctl start httpd
    systemctl enable httpd   
  EOF
  tags = {
    Name = "apache_called"
  }
}