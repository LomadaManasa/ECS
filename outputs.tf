output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}
output "alb_hostname" {
  value = aws_alb.alb.dns_name
}
output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}