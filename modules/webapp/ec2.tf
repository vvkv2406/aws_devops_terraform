
/*resource "aws_instance" "PublicEC2" {
  ami =   "ami-0578f2b35d0328762"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webapp_sg[0].id]
  subnet_id = aws_subnet.webapp_pub_subnet1.id
  key_name = var.key_pair_name
  tags = {
    Name = "PublicEC2"
  }
 depends_on = [aws_vpc.webapp_vpc,aws_subnet.webapp_pub_subnet1,aws_security_group.webapp_sg]
}

output "newec2" {
    value = aws_instance.PublicEC2
}*/
