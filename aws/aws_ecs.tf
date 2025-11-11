resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.project}-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_ssm_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# resource "aws_iam_role_policy_attachment" "ecs_task_role_ssm_policy" {
#   role       = aws_iam_role.ecs_task_execution_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
# }

# #################################
# ECS: Cluster
# #################################
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project}-cluster"
}


# #################################
# ECS: Task Definition
# #################################
resource "aws_ecs_task_definition" "ecs_db_task" {
  family                   = "${var.project}-db-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 4096
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn # enable exec

  container_definitions = file("./container/db.json")
}

# #################################
# ECS: Service
# #################################
resource "aws_ecs_service" "ecs_db_svc" {
  name    = "${var.project}-db-service"
  cluster = aws_ecs_cluster.ecs_cluster.id

  # task
  task_definition = aws_ecs_task_definition.ecs_db_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  platform_version       = "LATEST"
  enable_execute_command = true


  network_configuration {
    security_groups  = [aws_security_group.vpc_task_sg.id]
    subnets          = [for subnet in aws_subnet.subnets : subnet.id]
    assign_public_ip = true # enable public ip for task
  }

  depends_on = [aws_cloudwatch_log_group.task_log_group]
}

