###########################################
# CloudWatch Alarm for RDS CPU Utilization
###########################################

resource "aws_cloudwatch_metric_alarm" "rds_cpu_high" {
  alarm_name          = var.alarm_name
  alarm_description   = "Triggers when RDS CPU exceeds ${var.cpu_threshold}%"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = var.cpu_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBInstanceIdentifier = var.identifier
  }

  alarm_actions = [aws_sns_topic.rds_alerts.arn]
  ok_actions    = [aws_sns_topic.rds_alerts.arn]

  tags = var.tags
}

# SNS Topic for RDS Alerts
resource "aws_sns_topic" "rds_alerts" {
  name = var.rds_cpu_alerts

  tags = var.tags
}

# SNS Topic Subscription for Email Notifications
resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.rds_alerts.arn
  protocol  = "email"
  endpoint  = "altynai.nad@edu.312school.com"
}


