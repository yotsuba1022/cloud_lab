# VPC Flow Logs
resource "aws_flow_log" "vpc_flow_log" {
  iam_role_arn    = aws_iam_role.flow_log_role.arn
  log_destination = aws_cloudwatch_log_group.flow_log_group.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.this.id

  tags = merge(
    local.common_tags, { Name = "${local.prefix}-flow-log" })
}

resource "aws_cloudwatch_log_group" "flow_log_group" {
  name              = "/aws/${local.prefix}/vpc/flow-logs"
  retention_in_days = 5

  tags = merge(
    local.common_tags, { Name = "${local.prefix}-flow-log-group" })
}
