# ============================================================
#  modules/ec2/main.tf
#  EC2 — Hardened web server with Apache + Elastic IP
# ============================================================

# Get latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# SSH Key Pair
resource "aws_key_pair" "main" {
  key_name   = "${var.project}-key"
  public_key = file("~/.ssh/${var.project}-key.pub")
}

# EC2 Instance
resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.web_sg_id]
  key_name               = aws_key_pair.main.key_name
  iam_instance_profile   = var.iam_instance_profile

  # IMDSv2 enforced — blocks SSRF attacks on metadata
  metadata_options {
    http_tokens                 = "required"
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
  }

  # User data — installs Apache on first boot
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    cat > /var/www/html/index.html << 'HTML'
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <title>AWS Security Framework</title>
      <style>
        body { font-family: monospace; background: #060912; color: #00ff41; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; }
        .box { border: 1px solid #00ff41; padding: 40px; max-width: 600px; box-shadow: 0 0 30px #00ff4144; }
        h1 { font-size: 1.8rem; margin-bottom: 20px; }
        .item { padding: 8px 0; border-bottom: 1px solid #1a1a1a; }
        .check { color: #00ff41; }
        footer { margin-top: 20px; color: #555; font-size: 0.8rem; }
      </style>
    </head>
    <body>
      <div class="box">
        <h1>🔒 AWS Security Framework</h1>
        <div class="item"><span class="check">✅</span> IAM — Least Privilege Enforced</div>
        <div class="item"><span class="check">✅</span> S3 — Encrypted Audit Vault</div>
        <div class="item"><span class="check">✅</span> CloudTrail — All API Events Logged</div>
        <div class="item"><span class="check">✅</span> VPC — Network Isolated</div>
        <div class="item"><span class="check">✅</span> EC2 — Hardened Web Server</div>
        <div class="item"><span class="check">✅</span> CloudWatch + SNS — Monitoring Active</div>
        <footer>Deployed via Terraform | Region: us-east-1 | Built by John</footer>
      </div>
    </body>
    </html>
HTML
  EOF

  tags = {
    Name    = "${var.project}-web-server"
    Project = var.project
  }
}

# Elastic IP — static public IP
resource "aws_eip" "web" {
  instance = aws_instance.web.id
  domain   = "vpc"

  tags = {
    Name    = "${var.project}-eip"
    Project = var.project
  }
}
