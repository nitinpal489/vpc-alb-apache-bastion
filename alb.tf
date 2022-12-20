#calling security group here with 80 port and outward traffic.

resource "aws_security_group" "allow_lb" {
  name        = "allow_lb"
  description = "Allow load balancer"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "from vpc"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "from vpc"
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

  tags = {
    Name = "allow lb_sg "
  }
}


#creating the alb here.
resource "aws_lb" "alb-new" {
  name               = "apache-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_lb.id]
  subnets            = [aws_subnet.public[1].id, aws_subnet.public[2].id]

  tags = {
    Environment = "apache-alb"
  }
}

#target group
resource "aws_lb_target_group" "alb-tg" {
  name        = "lb-alb-targetgp"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
}

#attachment
resource "aws_lb_target_group_attachment" "test-targetgrp" {
  target_group_arn = aws_lb_target_group.alb-tg.arn
  target_id        = aws_instance.myapache1.id
  port             = 80
}

resource "aws_lb_listener" "front_end_listener" {
  load_balancer_arn = aws_lb.alb-new.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn
  }
}

resource "aws_lb_listener_rule" "apache" {
  listener_arn = aws_lb_listener.front_end_listener.arn

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn
  }
  condition {
    host_header {
      values = ["apache.com"]
    }
  }
}