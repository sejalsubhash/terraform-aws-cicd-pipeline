resource "aws_iam_role_policy_attachment" "codepipeline_s3_access" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_s3_bucket" "task_manager_bucket" {
    bucket = "task-manager-cicd-bucket-878787980934566777"
    
    tags = {
        Name = "TaskManagerCICDBucket"
    }
  
}

resource "aws_s3_bucket_ownership_controls" "artifact_bucket_ownership" {
  bucket = aws_s3_bucket.task_manager_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}