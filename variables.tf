
variable "aws_region" {
  description = "AWS Region for the Course Portal infrastructure"
  type        = string
  default     = "ap-south-1"
}

variable "db_identifier" {
  description = "RDS DB instance identifier"
  type        = string
  default     = "course-portal-db"
}

variable "db_name" {
  description = "Initial MySQL database name"
  type        = string
  default     = "courseportal"
}

variable "db_username" {
  description = "RDS master username"
  type        = string
  default     = "dbadmin"
}

variable "db_password" {
  description = "RDS master password; never commit this value"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "engine_version" {
  description = "Optional MySQL engine version; null uses the AWS default"
  type        = string
  default     = null
  nullable    = true
}

variable "backend_security_group_id" {
  description = "Security group ID attached to the backend EC2"
  type        = string
}
