##############################################
# CloudWatch Log Groups
##############################################

resource "aws_cloudwatch_log_group" "frontend" {
  name              = "/ecs/frontend"
  retention_in_days = 14

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-frontend-logs"
  })
}

resource "aws_cloudwatch_log_group" "backend" {
  name              = "/ecs/backend"
  retention_in_days = 14

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-backend-logs"
  })
}

##############################################
# ECS Cluster
##############################################

resource "aws_ecs_cluster" "main" {
  name = "${local.project_name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-cluster"
  })
}

##############################################
# Frontend Task Definition
##############################################

resource "aws_ecs_task_definition" "frontend" {

  family                   = "${local.project_name}-frontend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = tostring(local.frontend_cpu)
  memory = tostring(local.frontend_memory)

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name = local.frontend_container_name

      image = "${aws_ecr_repository.frontend.repository_url}:latest"

      essential = true

      portMappings = [
        {
          containerPort = local.frontend_port
          hostPort      = local.frontend_port
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.frontend.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-frontend-task"
  })
}

##############################################
# Backend Task Definition
##############################################

resource "aws_ecs_task_definition" "backend" {

  family                   = "${local.project_name}-backend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = tostring(local.backend_cpu)
  memory = tostring(local.backend_memory)

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name = local.backend_container_name

      image = "${aws_ecr_repository.backend.repository_url}:latest"

      essential = true

      portMappings = [
        {
          containerPort = local.backend_port
          hostPort      = local.backend_port
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.backend.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-backend-task"
  })
}

##############################################
# Frontend ECS Service
##############################################

resource "aws_ecs_service" "frontend" {

  name            = "${local.project_name}-frontend-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.frontend.arn

  desired_count = var.ecs_desired_count

  launch_type = "FARGATE"

  network_configuration {

    subnets = [
      aws_subnet.private_a.id,
      aws_subnet.private_b.id
    ]

    security_groups = [
      aws_security_group.frontend_sg.id
    ]

    assign_public_ip = false
  }

  load_balancer {

    target_group_arn = aws_lb_target_group.frontend.arn

    container_name = local.frontend_container_name

    container_port = local.frontend_port

  }

  depends_on = [
    aws_lb_listener.http
  ]

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-frontend-service"
  })

}

##############################################
# Backend ECS Service
##############################################

resource "aws_ecs_service" "backend" {

  name            = "${local.project_name}-backend-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.backend.arn

  desired_count = var.ecs_desired_count

  launch_type = "FARGATE"

  network_configuration {

    subnets = [
      aws_subnet.private_a.id,
      aws_subnet.private_b.id
    ]

    security_groups = [
      aws_security_group.backend_sg.id
    ]

    assign_public_ip = false
  }

  load_balancer {

    target_group_arn = aws_lb_target_group.backend.arn

    container_name = local.backend_container_name

    container_port = local.backend_port

  }

  depends_on = [
    aws_lb_listener.http
  ]

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-backend-service"
  })

}