# ============================================================
#  modules/ec2/outputs.tf
# ============================================================

output "instance_id" {
  value = aws_instance.web.id
}

output "public_ip" {
  value = aws_eip.web.public_ip
}
