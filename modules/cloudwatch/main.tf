# ============================================================
#  modules/cloudwatch/main.tf
#  CloudWatch + SNS — Monitoring and real-time alerts
# ============================================================

# SNS Topic — notification channel
resource "aws_sns_topic" "alerts" {
  name = "${var.project}-alerts"

  tags = {
    Name    = "${var.project}-alerts"
    Project = var.project
  }
}

# Subscribe email to SNS topic
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# CPU Alarm — detects crypto miners, DDoS, runaway processes
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.project}-high-cpu"
  alarm_description   = "ALERT: EC2 CPU exceeded 80% — possible attack"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 2
  threshold           = 80
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    InstanceId = var.instance_id
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
  ok_actions    = [aws_sns_topic.alerts.arn]
}

# Status Check Alarm — detects instance failures
resource "aws_cloudwatch_metric_alarm" "status_check" {
  alarm_name          = "${var.project}-status-check"
  alarm_description   = "ALERT: EC2 instance failed status check"
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  statistic           = "Maximum"
  period              = 60
  evaluation_periods  = 2
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"

  dimensions = {
    InstanceId = var.instance_id
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
}
