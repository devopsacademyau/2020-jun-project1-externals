resource "aws_alb_listener" "web_app" {
  load_balancer_arn = aws_alb.wp_alb.arn
  port              = var.alb_port
  protocol          = "HTTPS"
  depends_on        = [aws_alb_target_group.target_group]
  certificate_arn   = var.alb_certificate_arn

  default_action {
    target_group_arn = aws_alb_target_group.target_group.arn
    type             = "forward"
    
  }
}

