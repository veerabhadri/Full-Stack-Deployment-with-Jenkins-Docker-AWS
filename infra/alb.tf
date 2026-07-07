##############################################
# Application Load Balancer
##############################################

resource "aws_lb" "main" {
  name               = "${local.project_name}-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb_sg.id
  ]

  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  idle_timeout = var.alb_idle_timeout

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-alb"
  })
}

##############################################
# Frontend Target Group
##############################################

resource "aws_lb_target_group" "frontend" {
  name        = "fsd-frontend-tg"
  port        = local.frontend_port
  protocol    = "HTTP"
  target_type = "ip"

  vpc_id = aws_vpc.main.id

  health_check {
    enabled             = true
    path                = local.frontend_health_check
    protocol            = "HTTP"
    matcher             = "200"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 5
  }

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-frontend-tg"
  })
}

##############################################
# Backend Target Group
##############################################

resource "aws_lb_target_group" "backend" {
  name        = "fsd-backend-tg"
  port        = local.backend_port
  protocol    = "HTTP"
  target_type = "ip"

  vpc_id = aws_vpc.main.id

  health_check {
    enabled             = true
    path                = local.backend_health_check
    protocol            = "HTTP"
    matcher             = "200"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 5
  }

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-backend-tg"
  })
}

##############################################
# HTTP Listener
##############################################

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}

##############################################
# Backend Listener Rule
##############################################

resource "aws_lb_listener_rule" "backend" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }

  condition {
    path_pattern {
      values = [
        "/api",
        "/api/*"
      ]
    }
  }
}