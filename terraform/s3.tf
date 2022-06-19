resource "aws_s3_bucket" "pipeline_artifact" {
  bucket = "${var.project_name}-pipeline-bucket"
}

resource "aws_s3_bucket_acl" "example_bucket_acl" {
  bucket = aws_s3_bucket.pipeline_artifact.id
  acl    = "private"
}
