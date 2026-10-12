
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Discover the existing default VPC.
data "aws_vpc" "default" {
  default = true
}

# Discover existing subnets in the default VPC.
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Permit MySQL traffic only from the backend EC2 security group.
resource "aws_security_group" "rds" {
  name        = "${var.db_identifier}-rds-sg"
  description = "Allow MySQL only from the backend EC2 security group"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description     = "MySQL from backend EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.backend_security_group_id]
  }

  egress {
    description = "Outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.db_identifier}-rds-sg"
    Project     = "CourseEnrollmentPortal"
    ManagedBy   = "Terraform"
  }
}

# RDS subnet groups require subnets in at least two Availability Zones.
resource "aws_db_subnet_group" "course_portal" {
  name        = "${var.db_identifier}-subnets"
  description = "Subnets for the private Course Portal RDS instance"
  subnet_ids  = data.aws_subnets.default.ids

  tags = {
    Name      = "${var.db_identifier}-subnets"
    Project   = "CourseEnrollmentPortal"
    ManagedBy = "Terraform"
  }
}

# Private MySQL database.
resource "aws_db_instance" "course_portal" {
  identifier = var.db_identifier

  engine         = "mysql"
  engine_version = var.engine_version
  instance_class = var.db_instance_class

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.course_portal.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  publicly_accessible = false
  multi_az            = false

  backup_retention_period = 1
  auto_minor_version_upgrade = true
  deletion_protection    = true
  skip_final_snapshot    = false
  final_snapshot_identifier = "${var.db_identifier}-final"

  # Avoid applying changes immediately to an existing database.
  apply_immediately = false

  tags = {
    Name      = var.db_identifier
    Project   = "CourseEnrollmentPortal"
    ManagedBy = "Terraform"
  }
}
