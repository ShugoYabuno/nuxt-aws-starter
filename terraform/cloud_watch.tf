resource "aws_cloudwatch_log_group" "codebuild" {
  name = "/${var.project_name}/codebuild"
}
resource "aws_cloudwatch_log_group" "ecs" {
  name = "/${var.project_name}/ecs"
}
