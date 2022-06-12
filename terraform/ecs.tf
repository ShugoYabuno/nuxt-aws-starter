resource "aws_ecs_task_definition" "nuxt-aws-starter" {
  family                   = var.project_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = 512
  cpu                      = 256
  container_definitions    = file("./task-definitions/container_definitions.json")
  task_role_arn            = "arn:aws:iam::${var.aws_account_id}:role/ecsTaskExecutionRole"
  execution_role_arn       = "arn:aws:iam::${var.aws_account_id}:role/ecsTaskExecutionRole"

  tags = {
    Name = var.project_name
  }
}

resource "aws_ecs_cluster" "nuxt-aws-starter" {
  name = var.project_name

  tags = {
    Name = var.project_name
  }
}

resource "aws_ecs_cluster_capacity_providers" "nuxt-aws-starter" {
  cluster_name = aws_ecs_cluster.nuxt-aws-starter.name

  capacity_providers = ["FARGATE"]
}

resource "aws_ecs_service" "ecs_service" {
  cluster             = aws_ecs_cluster.nuxt-aws-starter.id
  launch_type         = "FARGATE"
  name                = var.project_name
  desired_count       = 1
  platform_version    = "LATEST"
  scheduling_strategy = "REPLICA"
  task_definition     = aws_ecs_task_definition.nuxt-aws-starter.arn

  network_configuration {
    assign_public_ip = "true"
    security_groups  = [aws_security_group.security_group.id]
    subnets          = [aws_subnet.subnet.id]
  }

  deployment_controller {
    type = "ECS"
  }
}
