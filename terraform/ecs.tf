resource "aws_ecs_task_definition" "task_definition" {
  family                   = var.project_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = 512
  cpu                      = 256
  container_definitions    = <<DEFINITION
  [
    {
      "name" : "${var.project_name}",
      "image" : "722081103407.dkr.ecr.ap-northeast-1.amazonaws.com/nuxt-aws-starter:def89bd6e9b049930556469663e7ad978c4f3499",
      "portMappings" : [
        {
          "containerPort" : 3000,
          "hostPort" : 3000,
          "protocol" : "tcp"
        }
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "${aws_cloudwatch_log_group.ecs.name}",
          "awslogs-region" : "ap-northeast-1",
          "awslogs-stream-prefix" : "ecs"
        }
      },
      "essential" : true
    }
  ]
  DEFINITION
  task_role_arn            = "arn:aws:iam::${var.aws_account_id}:role/ecsTaskExecutionRole"
  execution_role_arn       = "arn:aws:iam::${var.aws_account_id}:role/ecsTaskExecutionRole"

  tags = {
    Name = var.project_name
  }
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.project_name

  tags = {
    Name = var.project_name
  }
}

resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name = aws_ecs_cluster.ecs_cluster.name

  capacity_providers = [
    "FARGATE",
    "FARGATE_SPOT"
  ]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }
}

resource "aws_ecs_cluster_capacity_providers" "cluster_capacity_providers" {
  cluster_name = aws_ecs_cluster.ecs_cluster.name

  capacity_providers = ["FARGATE"]
}

resource "aws_ecs_service" "ecs_service" {
  cluster             = aws_ecs_cluster.ecs_cluster.id
  launch_type         = "FARGATE"
  name                = var.project_name
  desired_count       = 1
  platform_version    = "LATEST"
  scheduling_strategy = "REPLICA"
  task_definition     = aws_ecs_task_definition.task_definition.arn

  network_configuration {
    assign_public_ip = "true"
    security_groups  = [aws_security_group.security_group.id]
    subnets          = [aws_subnet.main.id]
  }

  deployment_controller {
    type = "ECS"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.green.arn
    container_name   = var.project_name
    container_port   = 3000
  }

  tags = {
    Name = var.project_name
  }
}
