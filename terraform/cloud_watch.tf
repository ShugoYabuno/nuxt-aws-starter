resource "aws_cloudwatch_log_group" "yada" {
  name = "/ecs/${var.project_name}"

  tags = {
    name = var.project_name
  }
}
