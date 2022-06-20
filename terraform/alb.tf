resource "aws_lb" "lb" {
  name               = var.project_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.security_group.id]

  subnet_mapping {
    subnet_id = aws_subnet.main.id
  }
  subnet_mapping {
    subnet_id = aws_subnet.secondary.id
  }

  tags = {
    Name = var.project_name
  }
}

resource "aws_lb_target_group" "blue" {
  target_type = "ip"
  name        = "${var.project_name}-blue"
  protocol    = "HTTP"
  port        = 3000
  vpc_id      = aws_vpc.main.id

  health_check {
    port                = 3000
    protocol            = "HTTP"
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = 200
  }

  tags = {
    Name = var.project_name
  }
}

resource "aws_lb_target_group" "green" {
  target_type = "ip"
  name        = "${var.project_name}-green"
  protocol    = "HTTP"
  port        = 3000
  vpc_id      = aws_vpc.main.id

  health_check {
    port                = 3000
    protocol            = "HTTP"
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = 200
  }

  tags = {
    Name = var.project_name
  }
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.lb.id
  protocol          = "HTTP"
  port              = 80
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green.arn
  }
}
