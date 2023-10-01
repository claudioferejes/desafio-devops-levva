##Criando o Cluster ECS
resource "aws_ecs_cluster" "levva_cluster" {
  name = "levva_cluster"  # Nome do seu cluster ECS
}


#Politicas e Permissões
resource "aws_iam_role" "ecs_execution_role_levva" {
  name = "ecs_execution_role_levva"
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
resource "aws_iam_policy_attachment" "ecs_execution_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  roles      = [aws_iam_role.ecs_execution_role_levva.name]
  name       = "ecs_execution_role_attachment"
}

##Propriedades e configurações do ECS
resource "aws_ecs_task_definition" "levva_task" {
  family                   = "levva-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn        = aws_iam_role.ecs_execution_role_levva.arn

  # Configuração de recursos da tarefa (CPU e memória)
  cpu = "256"
  memory = "512"

  container_definitions = jsonencode([
    {
      name  = "levva_desafio"
      image = "${aws_ecr_repository.levva_ecr.repository_url}:latest"
      memory = 512
      cpu    = 128
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "levva_ecs" {
  name            = "levva_service"
  cluster         = aws_ecs_cluster.levva_cluster.id
  task_definition = aws_ecs_task_definition.levva_task.arn
  launch_type     = "FARGATE"
  network_configuration {
    subnets = [aws_subnet.public_01.id, aws_subnet.public_02.id]
    security_groups = [aws_security_group.levva_nsg.id]
    assign_public_ip = true
  }
}