# 🚀 Task Manager CI/CD Pipeline using Terraform and AWS

This project demonstrates an **end-to-end CI/CD pipeline** for deploying a **Dockerized Python Flask application** using Infrastructure as Code with Terraform and AWS DevOps services.

The pipeline automatically builds, stores, and deploys the application whenever code is pushed to the repository.

---

# 🏗 Architecture Overview

The CI/CD workflow integrates the following services:

* **GitHub** – Source code repository
* **AWS CodePipeline** – CI/CD pipeline orchestration
* **AWS CodeBuild** – Build and test stage
* **Amazon ECR** – Docker image storage
* **AWS CodeDeploy** – Deployment automation
* **Amazon EC2** – Application hosting
* **Terraform** – Infrastructure provisioning

### Workflow

1. Developer pushes code to GitHub
2. CodePipeline detects the change
3. CodeBuild builds the Docker image
4. Image is pushed to Amazon ECR
5. CodeDeploy pulls the image
6. Application container is deployed on EC2

---

# 📂 Project Structure

```
.
├── app.py
├── Dockerfile
├── requirements.txt
├── buildspec.yml
├── appspec.yml
├── scripts
│   ├── start.sh
│   └── stop.sh
│
├── terraform
│   ├── provider.tf
│   ├── variables.tf
│   ├── s3.tf
│   ├── ecr.tf
│   ├── iam.tf
│   ├── codebuild.tf
│   ├── codedeploy.tf
│   └── codepipeline.tf
```

---

# 🐳 Application

The application is a simple **Flask-based Task Manager** packaged as a Docker container.

The container is built automatically in the CI/CD pipeline and pushed to Amazon ECR.

---

# ⚙ Infrastructure as Code

All AWS resources are created using **Terraform**, including:

* ECR Repository
* CodeBuild Project
* CodeDeploy Application
* CodePipeline
* IAM Roles
* Artifact S3 Bucket

---

# 🔧 Prerequisites

Before deploying this project ensure you have:

* Terraform installed
* AWS CLI configured
* Docker installed
* GitHub repository with the application code
* AWS account with required permissions

Configure AWS CLI:

```
aws configure
```

---

# 🚀 Deployment Steps

### 1 Clone the repository

```
git clone https://github.com/<your-username>/<repo-name>.git
cd <repo-name>
```

---

### 2 Initialize Terraform

```
terraform init
```

---

### 3 Review infrastructure plan

```
terraform plan
```

---

### 4 Deploy infrastructure

```
terraform apply
```

---

# 🔄 CI/CD Pipeline Flow

1️⃣ Code pushed to GitHub
2️⃣ CodePipeline triggers automatically
3️⃣ CodeBuild installs dependencies and builds Docker image
4️⃣ Docker image pushed to Amazon ECR
5️⃣ CodeDeploy deploys container on EC2 instance

---

# 🐳 Docker Build Process

The pipeline performs the following steps:

* Install Python dependencies
* Run unit tests using pytest
* Build Docker image
* Tag Docker image
* Push image to Amazon ECR

---

# 📦 Deployment Process

CodeDeploy runs scripts on the EC2 instance:

### Stop existing container

```
scripts/stop.sh
```

### Start new container

```
scripts/start.sh
```

The latest Docker image from ECR is pulled and deployed automatically.

---

# 🔐 Security and IAM

IAM roles are used to allow:

* CodeBuild to push images to ECR
* CodePipeline to orchestrate services
* CodeDeploy to access EC2 instances
* EC2 to pull images from ECR

---

# 📊 Key DevOps Concepts Demonstrated

* Infrastructure as Code (Terraform)
* CI/CD automation
* Containerization using Docker
* AWS DevOps services integration
* Automated deployment pipeline
* Cloud infrastructure management

---

# 👩‍💻 Author

**Sejal Pawar**

Cloud | DevOps | AWS | Terraform | Docker

---
