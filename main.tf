resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "MyVPC"
  }
  
}

resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet_cidrs)
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = var.avaibility_zones[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "PublicSubnet-${count.index}"
  }
}



resource "aws_internet_gateway" "my_igw" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
        Name = "MyIGW"
    }
  
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.my_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_igw.id
    }
    tags = {
        Name = "PublicRouteTable"
    }
}

resource "aws_route_table_association" "public_subnet_assoc" {
    count = length(var.public_subnet_cidrs)
    subnet_id = aws_subnet.public_subnet[count.index].id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "task_sg" {
    name = "task-manager-sg"
    description = "Allow HTTP and SSH traffic"
    vpc_id = aws_vpc.my_vpc.id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
  
}

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 5000
        to_port = 5000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

}


resource "aws_s3_bucket_policy" "artifact_bucket_policy" {
  bucket = aws_s3_bucket.task_manager_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = [
            aws_iam_role.ec2_role.arn,
            aws_iam_role.codepipeline_role.arn
          ]
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.task_manager_bucket.arn,
          "${aws_s3_bucket.task_manager_bucket.arn}/*"
        ]
      }
    ]
  })
}