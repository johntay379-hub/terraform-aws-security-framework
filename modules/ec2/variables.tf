# ============================================================
#  modules/ec2/variables.tf
# ============================================================

variable "project" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "web_sg_id" {
  type = string
}

variable "iam_instance_profile" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "region" {
  type = string
}
