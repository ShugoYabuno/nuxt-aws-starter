resource "aws_iam_role" "codepipeline" {
  name               = "${var.project_name}-codepipeline"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assumerole.json
}

resource "aws_iam_role" "codebuild" {
  name               = "${var.project_name}-codebuild"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assumerole.json
}

resource "aws_iam_policy" "codepipeline" {
  name   = "${var.project_name}-codepipeline-policy"
  policy = data.aws_iam_policy_document.codepipeline.json
}

resource "aws_iam_policy" "codestar" {
  name = "${var.project_name}-codestar"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "codestar-connections:UseConnection",
        ]
        Effect   = "Allow"
        Resource = aws_codestarconnections_connection.codestarconnections_connection.arn
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codepipeline" {
  role       = aws_iam_role.codepipeline.id
  policy_arn = aws_iam_policy.codepipeline.arn
}

resource "aws_iam_role_policy_attachment" "codestar" {
  role       = aws_iam_role.codepipeline.id
  policy_arn = aws_iam_policy.codestar.arn
}

data "aws_iam_policy_document" "codepipeline_assumerole" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "codebuild_assumerole" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "codepipeline" {
  statement {
    effect = "Allow"
    actions = [
      "s3:List*",
      "s3:Get*",
      "s3:PutObject"
    ]
    resources = [
      aws_s3_bucket.pipeline_artifact.arn,
      "${aws_s3_bucket.pipeline_artifact.arn}/*"
    ]
  }
}

data "aws_iam_policy_document" "codebuild" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "ecr:*"
    ]
    resources = [
      aws_ecr_repository.ecr_repository.arn
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:List*",
      "s3:Get*",
      "s3:PutObject"
    ]
    resources = [
      aws_s3_bucket.pipeline_artifact.arn,
      "${aws_s3_bucket.pipeline_artifact.arn}/*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      aws_cloudwatch_log_group.codebuild.arn,
    ]
  }
}

resource "aws_kms_key" "a" {}

resource "aws_kms_alias" "s3kmskey" {
  name          = "alias/${var.project_name}-key"
  target_key_id = aws_kms_key.a.key_id
}
