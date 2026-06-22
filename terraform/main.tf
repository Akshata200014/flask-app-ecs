provider "aws" {
  region = "ap-south-1" # Mumbai
}

# 1. Get the Default VPC and Subnets (So we don't have to create new ones)
data "aws_vpc" "default" { default = true }
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# 2. ECS Cluster
resource "aws_ecs_cluster" "flask_cluster" {
  name = "flask-cluster"
}

# 3. Security Group (The Firewall)
resource "aws_security_group" "flask_sg" {
  name        = "flask-app-sg"
  description = "Allow port 8080"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 4. ECS Task Definition
resource "aws_ecs_task_definition" "flask_task" {
  family                   = "flask-app-task-d"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "arn:aws:iam::951013218351:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name      = "flask-app-container"
      image     = "akshata14/flask-python-app:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
      environment = [
        { name = "PYTHONPATH", value = "/app/lib" },
        { name = "PYTHONUNBUFFERED", value = "1" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/flask-app-task-d"
          "awslogs-region"        = "ap-south-1"
          "awslogs-stream-prefix" = "ecs"
          "awslogs-create-group"  = "true"
        }
      }
    }
  ])
}

# 5. ECS Service
resource "aws_ecs_service" "flask_service" {
  name            = "flask-service"
  cluster         = aws_ecs_cluster.flask_cluster.id
  task_definition = aws_ecs_task_definition.flask_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.flask_sg.id]
    assign_public_ip = true
  }
}
