output "webapp_vpc_arn" {
    value = aws_vpc.webapp_vpc.arn
}

output "webapp_vpc_id" {
    value = aws_vpc.webapp_vpc.id
}

output "subnet_ids" {
    value = [aws_subnet.webapp_pub_subnet1.id,aws_subnet.webapp_pub_subnet2.id]
}