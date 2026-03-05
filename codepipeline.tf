############################
# CodePipeline IAM Role
############################

resource "aws_iam_role" "codepipeline_role" {
  name = "task-manager-codepipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "codepipeline.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "codepipeline_codestar_access" {
  name = "AllowUseCodeStarConnection"
  role = aws_iam_role.codepipeline_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "codestar-connections:UseConnection"
        ]
        Resource = aws_codestarconnections_connection.github.arn
      }
    ]
  })
}

resource "aws_iam_role_policy" "codepipeline_codebuild_access" {
  name = "AllowCodeBuildStart"
  role = aws_iam_role.codepipeline_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "codebuild:StartBuild",
          "codebuild:BatchGetBuilds"
        ]
        Resource = aws_codebuild_project.task_build.arn
      }
    ]
  })
}

############################
# Attach Required Policies
############################

# Full access to CodePipeline service actions
resource "aws_iam_role_policy_attachment" "codepipeline_policy" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess"
}

# S3 access for artifact bucket
resource "aws_iam_role_policy_attachment" "codepipeline_s3" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

############################
# CodePipeline Resource
############################

resource "aws_codepipeline" "task_pipeline" {
  name     = "task-manager-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.task_manager_bucket.bucket
    type     = "S3"
  }

  ############################
  # SOURCE STAGE
  ############################
  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.github.arn
        FullRepositoryId = "sejalsubhash/Dockerized_Python_App_Deployment_using_AWS_CICD"
        BranchName       = "main"
      }
    }
  }

  ############################
  # BUILD STAGE
  ############################
  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = aws_codebuild_project.task_build.name
      }
    }
  }

  ############################
  # DEPLOY STAGE
  ############################
  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      version         = "1"
      input_artifacts = ["build_output"]

      configuration = {
        ApplicationName     = aws_codedeploy_app.task_app.name
        DeploymentGroupName = aws_codedeploy_deployment_group.task_deploy_group.deployment_group_name
      }
    }
  }
}