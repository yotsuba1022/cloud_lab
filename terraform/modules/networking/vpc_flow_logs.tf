resource "aws_cloudwatch_log_group" "flow_log_group" {
  name              = "/aws/${local.prefix}/vpc/flow-logs"
  retention_in_days = 5

  tags = merge(
  local.common_tags, { Name = "${local.prefix}-flow-log-group" })
}
resource "aws_flow_log" "vpc_flow_log" {
  iam_role_arn    = aws_iam_role.flow_log_role.arn
  log_destination = aws_cloudwatch_log_group.flow_log_group.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.this.id

  depends_on = [
    aws_cloudwatch_log_group.flow_log_group,
    aws_vpc.this
  ]

  tags = merge(
  local.common_tags, { Name = "${local.prefix}-flow-log" })
}

resource "null_resource" "delete_flow_log" {
  triggers = {
    prefix = local.prefix
    region = var.aws_region
  }

  depends_on = [aws_flow_log.vpc_flow_log]

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      echo "Waiting for VPC Flow Log to be deleted..."
      sleep 10

      # Check if VPC Flow Log still exists
      FLOW_LOG_ID=$(aws ec2 describe-flow-logs --region ${self.triggers.region} --query "FlowLogs[?LogGroupName=='/aws/${self.triggers.prefix}/vpc/flow-logs'].FlowLogId" --output text)
      
      if [ ! -z "$FLOW_LOG_ID" ]; then
        echo "VPC Flow Log still exists, deleting manually..."
        aws ec2 delete-flow-logs --flow-log-ids $FLOW_LOG_ID --region ${self.triggers.region}
      else
        echo "VPC Flow Log already deleted."
      fi

      # Check if CloudWatch Log Group still exists
      LOG_GROUP_NAME="/aws/${self.triggers.prefix}/vpc/flow-logs"
      if aws logs describe-log-groups --log-group-name-prefix "$LOG_GROUP_NAME" --region ${self.triggers.region} --query "logGroups[?logGroupName=='$LOG_GROUP_NAME']" --output text | grep -q "$LOG_GROUP_NAME"; then
        echo "CloudWatch Log Group still exists, deleting manually..."
        aws logs delete-log-group --log-group-name "$LOG_GROUP_NAME" --region ${self.triggers.region}
      else
        echo "CloudWatch Log Group already deleted."
      fi
    EOT
  }

}
