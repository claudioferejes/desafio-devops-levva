resource "aws_security_group" "alb_sg_levva" {
  name_prefix = "alb-sg-levva-"
}

resource "aws_security_group_rule" "alb_ingress_levva" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg_levva.id
}

resource "aws_lb_target_group" "levva_target_group" {
  name        = "levva-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.levva_vpc.id
}

resource "aws_lb_listener" "levva_listener" {
  load_balancer_arn = aws_lb.levva_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    content_type     = "text/plain"
    status_code      = "200"
    fixed_response   = "Hello, world!"
  }
}

resource "aws_lb_listener_rule" "levva_listener_rule" {
  listener_arn = aws_lb_listener.levva_listener.arn

  action {
    type             = "fixed-response"
    content_type     = "text/plain"
    status_code      = "200"
    fixed_response   = "Hello, world!"
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}

resource "aws_lb_target_group_attachment" "levva_target_group_attachment" {
  target_group_arn = aws_lb_target_group.levva_target_group.arn
  target_id        = aws_ecs_task_definition.levva_task.arn
}
