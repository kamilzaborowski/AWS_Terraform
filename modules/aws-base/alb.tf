resource "aws_lb" "alb" {
  name               = "alb-test"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow.id]
  subnets            = [for subnet in aws_subnet.public_subnets : subnet.id]

  tags = {
    Name = "ALB"
  }
}

resource "aws_lb_target_group" "alb_target_group" {
  depends_on = [aws_vpc.default_vpc]
  vpc_id     = aws_vpc.default_vpc.id
  name       = "Test-alb-tg"
  port       = 80
  protocol   = "HTTP"
}

resource "aws_lb_listener" "alb_listener" {
  depends_on        = [aws_lb.alb, aws_lb_target_group.alb_target_group]
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}

resource "aws_lb_target_group_attachment" "alb_target_group_attachment" {
  depends_on       = [aws_lb_target_group.alb_target_group, aws_instance.server]
  count            = length(aws_instance.server)
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  port             = 80
  target_id        = aws_instance.server[count.index].id
}