output "subnet_id" {
  value = aws_subnet.subnet_remote_state.id
}

output "sg_id" {
  value = aws_security_group.sg_remote_state.id
}

