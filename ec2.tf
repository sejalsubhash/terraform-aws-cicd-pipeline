resource "aws_iam_role" "ec2_role" {
  name = "task-manager-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_s3_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "ec2_ecr" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_role_policy_attachment" "ec2_codedeploy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "task-manager-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_key_pair" "task_key" {
  key_name   = var.key_name
  public_key = file("C:\\Users\\SejalPawar\\Desktop\\git-projects\\CICD-terra\\my-ssh-key.pub")
}

resource "aws_instance" "task_server" {
  ami           = "ami-051a31ab2f4d498f5"
  instance_type = var.instance_type
  key_name = aws_key_pair.task_key.key_name
  subnet_id = aws_subnet.public_subnet[0].id

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  vpc_security_group_ids = [aws_security_group.task_sg.id]

  user_data = file("userdata.sh")

  tags = {
    Name = "Working-server"
  }
}

