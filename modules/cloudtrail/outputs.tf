# ============================================================
#  modules/cloudtrail/outputs.tf
# ============================================================

output "trail_arn" {
  description = "CloudTrail ARN"
  value       = aws_cloudtrail.main.arn
}
