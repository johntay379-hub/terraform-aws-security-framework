# ============================================================
#  modules/s3/variables.tf
# ============================================================

variable "project" {
  description = "Project name for tagging"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
  default     = "506234426979"
}