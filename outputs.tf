
output "rds_endpoint" {
  description = "RDS endpoint hostname for backend configuration"
  value       = aws_db_instance.course_portal.address
}

output "rds_port" {
  description = "RDS MySQL port"
  value       = aws_db_instance.course_portal.port
}

output "database_name" {
  description = "Initial database name"
  value       = aws_db_instance.course_portal.db_name
}

output "rds_security_group_id" {
  description = "Security group attached to RDS"
  value       = aws_security_group.rds.id
}

output "rds_publicly_accessible" {
  description = "Whether RDS has public accessibility enabled"
  value       = aws_db_instance.course_portal.publicly_accessible
}
