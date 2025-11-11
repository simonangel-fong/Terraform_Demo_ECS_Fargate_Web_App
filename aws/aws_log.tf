resource "aws_cloudwatch_log_group" "task_log_group" {
  name              = "/ecs/task/postgres"
  retention_in_days = 7
}
