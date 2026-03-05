output "ec2_public_ip" {
  value = aws_instance.task_server.public_ip
}

output "ecr_url" {
  value = aws_ecr_repository.task_manager.repository_url
}