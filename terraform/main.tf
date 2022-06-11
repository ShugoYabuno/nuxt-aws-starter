resource "aws_ecr_repository" "nuxt_aws_starter" {
  name                 = "nuxt_aws_starter"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
