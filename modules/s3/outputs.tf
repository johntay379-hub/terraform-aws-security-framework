# ============================================================
#  modules/s3/outputs.tf
# ============================================================

output "bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.audit_vault.bucket
}

output "bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.audit_vault.arn
}