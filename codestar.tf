resource "aws_codestarconnections_connection" "github" {
  name          = "github-connection-task-manager"
  provider_type = "GitHub"
}