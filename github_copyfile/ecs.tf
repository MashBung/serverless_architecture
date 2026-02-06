/*resource "aws_ecs_cluster" "main"{
    name = "your-cluster"
}

resource "aws_cloudwatch_log_group" "fastapi" {
  name              = "/yourecs"
  retention_in_days = 1  # 자동 삭제 (비용 절감)
}

resource "aws_ecs_task_definition" "fastapi"{
    family = "your-task"
    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu = "256"
    memory = "512"
    execution_role_arn = "your-arn"
    task_role_arn = "your-arn"

    container_definitions = jsonencode([
        {
            name = "your-container"
            image = "your-image"
            essential = true

            portMappings = [
                {
                    containerPort = your-port
                    protocol = "tcp"
                }
            ]

            environment  = [
                {
                    name = "AWS_REGION"
                    value = "your-region"
                },
                {
                    name = "S3_BUCKET_NAME"
                    value = "your-bucketname"
                }
            ]

            logConfiguration = {
                logDriver = "awslogs"
                options = {
                    "awslogs-group" = "/yourecs"
                    "awslogs-region" = "your-region"
                    "awslogs-stream-prefix" = "ecs"

                }
            }
        }
    ])
}

data "aws_vpc" "default"{
    default = true
}

data "aws_subnets" "default"{
    filter{
        name = "vpc-id"
        values = [data.aws_vpc.default.id]
    }
}

resource "aws_security_group" "fastapi"{
    name = "your-ecs-sg"
    vpc_id = data.aws_vpc.default.id

    ingress{
        from_port = your-port
        to_port = your-port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_service" "fastapi"{
    name = "your-service"
    cluster = aws_ecs_cluster.main.id
    task_definition = aws_ecs_task_definition.fastapi.arn
    desired_count = 1
    launch_type = "FARGATE"

    network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.fastapi.id]
    assign_public_ip = true
  }
  health_check_grace_period_seconds = 60
}

# 출력
output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  value = aws_ecs_service.fastapi.name
}*/