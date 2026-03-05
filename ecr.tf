resource "aws_ecr_repository" "task_manager" {
  name                 = "task-manager-cicd"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true
}