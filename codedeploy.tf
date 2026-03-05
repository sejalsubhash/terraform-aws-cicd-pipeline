resource "aws_iam_role_policy_attachment" "codedeploy_s3" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role" "codedeploy_role" {
  name = "task-manager-codedeploy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "codedeploy.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}



resource "aws_iam_role_policy_attachment" "codedeploy_policy" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

resource "aws_codedeploy_app" "task_app" {
  name = "task-manager-cicd"
  compute_platform = "Server"
}

resource "aws_codedeploy_deployment_group" "task_deploy_group" {
  app_name              = aws_codedeploy_app.task_app.name
  deployment_group_name = "task-manager-deployment-group"
  service_role_arn      = aws_iam_role.codedeploy_role.arn

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = "Working-server"
    }
  }

  deployment_style {
    deployment_type = "IN_PLACE"
  }
}