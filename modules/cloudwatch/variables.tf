# ============================================================
#  modules/cloudwatch/variables.tf
# ============================================================

variable "project" {
  type = string
}

variable "instance_id" {
  type = string
}

variable "alert_email" {
  type = string
}

variable "region" {
  type = string
}
