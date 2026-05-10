# ============================================================
#  modules/vpc/variables.tf
# ============================================================

variable "project" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidr" {
  type = string
}

variable "private_subnet_cidr" {
  type = string
}

variable "region" {
  type = string
}
