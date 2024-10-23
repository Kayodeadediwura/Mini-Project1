output "frontend_node_1_public_ip" {
  value = aws_instance.frontend_node_1.public_ip
}

output "frontend_node_2_public_ip" {
  value = aws_instance.frontend_node_2.public_ip
}

output "backend_1_public_ip" {
  value = aws_instance.backend_1.public_ip
}

output "backend_2_public_ip" {
  value = aws_instance.backend_2.public_ip
}

output "mysql_database_public_ip" {
  value = aws_instance.mysql_database.public_ip
}