# Creating ECS Role 
resource aws_iam_role "ecs" {
  name = "${var.project_name}-ecs-role"
  assume_role_policy = jsonencode(
    {
      Version = "2008-10-17"
      Statement = [
        {
          Effect = "Allow"
          Principal = {
            Service = "ecs-tasks.amazonaws.com"
          }
          Action = "sts:AssumeRole"
        }
      ]
    }
  )
}

# Creating IAM Policy to access ECR
resource "aws_iam_policy" "ecrpolicy" {
  name        = "ecrpolicy"
  path        = "/"
  description = "Policy to access ECR"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "ecr:BatchCheckLayerAvailability",
            "ecr:BatchGetImage",
            "ecr:GetDownloadUrlForLayer",
            "ecr:GetAuthorizationToken"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
}


resource "aws_iam_role_policy_attachment" "ecs1" {
  role       = aws_iam_role.ecs.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs2" {
  role       = aws_iam_role.ecs.name
  policy_arn = aws_iam_policy.ecrpolicy.arn
}

