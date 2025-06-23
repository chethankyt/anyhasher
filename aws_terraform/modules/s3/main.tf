data "aws_iam_policy_document" "website_policy" {
  statement {
    actions = [
      "s3:*"
    ]
    principals {
      identifiers = ["*"]
      type = "AWS"
    }
    resources = [
      "arn:aws:s3:::${var.bucket_name}/*"
    ]
  }
}

resource "aws_s3_bucket" "frontend" {
  bucket = var.bucket_name
  force_destroy = true
  tags = {
    Purpose = "Learning GitOps CI/CD"
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.frontend.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.frontend.id
  policy = data.aws_iam_policy_document.website_policy.json
}

resource "aws_s3_bucket_website_configuration" "frontend_configuration" {
  bucket = aws_s3_bucket.frontend.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

variable "bucket_name" {
  description = "Terraform website bucket name"
}

output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.frontend_configuration.website_endpoint
}

output "bucket_name" {
  value = aws_s3_bucket.frontend.id
}