resource "aws_vpc" "webapp_vpc" {
  cidr_block = var.vpc_config["cidr"]
  enable_dns_hostnames = true
  enable_dns_support = true
  instance_tenancy = lookup(var.vpc_config,"instance_tenancy","default")
    tags = {
        Name = local.name
    }
}

/*resource "aws_subnet" "webapp_subnet" {
  vpc_id      = aws_vpc.webapp_vpc.id
  
  count = var.vpc_config["number_of_subnets"]
  map_public_ip_on_launch = true
  cidr_block = length(var.subnet_cidrs) > 0 ? var.subnet_cidrs[count.index] : cidrsubnet(var.vpc_config["cidr"],ceil(log(var.vpc_config["number_of_subnets"],2)),count.index)
  availability_zone = length (var.subnet_availability_zone_ids) > 0 ? null : sort(data.aws_availability_zones.available.names)[count.index]
  availability_zone_id = length (var.subnet_availability_zone_ids) > 0 ? var.subnet_availability_zone_ids[count.index] : null
  tags = {
    Name = format("%s-sn-%s",local.name,count.index+1)
  }
  depends_on = [aws_vpc.webapp_vpc]
} */


resource "aws_subnet" "webapp_pub_subnet1" {
  vpc_id      = aws_vpc.webapp_vpc.id
  
  map_public_ip_on_launch = true
  cidr_block = var.subnet_cidrs[0]
  availability_zone_id = var.subnet_availability_zone_ids[0]
  tags = {
    Name = format("%s-sn-%s",local.name,"pub1"),
    "kubernetes.io/role/elb" = 1
  }
  depends_on = [aws_vpc.webapp_vpc]
} 

resource "aws_subnet" "webapp_pub_subnet2" {
  vpc_id      = aws_vpc.webapp_vpc.id
  
  map_public_ip_on_launch = true
  cidr_block = var.subnet_cidrs[1]
  availability_zone_id = var.subnet_availability_zone_ids[1]
  tags = {
    Name = format("%s-sn-%s",local.name,"pub2"),
    "kubernetes.io/role/elb" = 1
  }
  depends_on = [aws_vpc.webapp_vpc]
} 


resource "aws_security_group" "webapp_sg" {
  vpc_id     = aws_vpc.webapp_vpc.id
  count = var.vpc_config["number_of_sg"]
  tags = {
    Name = format("%s-sg-%s",local.name,count.index+1)
  }

    ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.webapp_vpc.id
  tags = {
    Name = local.name
  }
  depends_on = [aws_vpc.webapp_vpc]
}

resource "aws_eip" "lb" {
  depends_on    = [aws_internet_gateway.gw]
  vpc           = true
  tags = {
    Name = local.name
  }
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.lb.id
  subnet_id     = aws_subnet.webapp_pub_subnet1.id
  depends_on = [aws_internet_gateway.gw]
  tags = {
    Name = local.name
  }
}

resource "aws_route_table" "PublicRouteTable1" {
  vpc_id = aws_vpc.webapp_vpc.id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
      Name = "PublicRouteTable1"
  }
  depends_on = [aws_vpc.webapp_vpc,aws_internet_gateway.gw]
}

resource "aws_route_table" "PublicRouteTable2" {
  vpc_id     = aws_vpc.webapp_vpc.id
  route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.natgw.id
  }
  tags = {
    Name = "PublicRouteTable2"
  }
  depends_on = [aws_vpc.webapp_vpc,aws_nat_gateway.natgw]
}

resource "aws_route_table_association" "PublicRouteTable1association" {
  subnet_id      = aws_subnet.webapp_pub_subnet1.id
  route_table_id = aws_route_table.PublicRouteTable1.id
  depends_on     = [aws_subnet.webapp_pub_subnet1,aws_route_table.PublicRouteTable1]
}

resource "aws_route_table_association" "PublicRouteTable2association" {
  subnet_id      = aws_subnet.webapp_pub_subnet2.id
  route_table_id = aws_route_table.PublicRouteTable2.id
  depends_on = [aws_subnet.webapp_pub_subnet2,aws_route_table.PublicRouteTable2]
}