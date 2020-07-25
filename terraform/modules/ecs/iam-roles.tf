resource aws_iam_role "ecs-iam-role" {
     name = "${var.project_name}-ecs-role"
     assume_role_policy =jsonencode([
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "",
                "Effect": "Allow",
                "Principal": {
                    "Service": "ecs-tasks.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    }
])
}

resource "aws_iam_role_policy_attachment" "ecs-iam-policy" {
  role       = aws_iam_role.ecs-iam-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}