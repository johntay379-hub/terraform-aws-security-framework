# ============================================================
#  modules/s3/main.tf
#  S3 — Encrypted, versioned, private audit vault
# ============================================================

# Create the S3 bucket
resource "aws_s3_bucket" "audit_vault" {
  bucket = "${var.project}-audit-logs-2026"

  tags = {
    Name    = "${var.project}-audit-logs-2026"
    Project = var.project
  }
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "audit_vault" {
  bucket                  = aws_s3_bucket.audit_vault.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# Enable versioning — protects logs from deletion
resource "aws_s3_bucket_versioning" "audit_vault" {
  bucket = aws_s3_bucket.audit_vault.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable AES-256 encryption at rest
resource "aws_s3_bucket_server_side_encryption_configuration" "audit_vault" {
  bucket = aws_s3_bucket.audit_vault.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Bucket policy — CloudTrail can write, nothing else
resource "aws_s3_bucket_policy" "audit_vault" {
  bucket = aws_s3_bucket.audit_vault.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AWSCloudTrailAclCheck"
        Effect    = "Allow"
        Principal = { Service = "cloudtrail.amazonaws.com" }
        Action    = "s3:GetBucketAcl"
        Resource  = aws_s3_bucket.audit_vault.arn
      },
      {
        Sid       = "AWSCloudTrailWrite"
        Effect    = "Allow"
        Principal = { Service = "cloudtrail.amazonaws.com" }
        Action    = "s3:PutObject"
        Resource  = "${aws_s3_bucket.audit_vault.arn}/cloudtrail/AWSLogs/${var.account_id}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}