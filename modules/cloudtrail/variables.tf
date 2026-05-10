# ============================================================
#  modules/cloudtrail/variables.tf
# ============================================================

variable "project" {
  description = "Project name"
  type        = string
}

variable "bucket_name" {
  description = "S3 bucket name for CloudTrail logs"
  type        = string
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
}
