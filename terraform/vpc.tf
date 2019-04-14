# Appliction VPC
resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr}"

  tags {
    Name = "balder_ah_vpc"
  }
}

# Internet Gateway 
resource "aws_internet_gateway" "frontend_igw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "balder_app_gateway"
  }
}

# Application Frontend Subnet for the VPC
resource "aws_subnet" "public" {
  vpc_id                  = "${aws_vpc.main.id}"
  availability_zone       = "${element(var.azs, 0)}"
  cidr_block              = "${element(var.subnets_cidr, 0)}"
  map_public_ip_on_launch = true

  tags {
    Name = "${element(var.app, 0)}_subnet"
  }
}

# Create Route table, attach internet gateway and associate with public subnet
resource "aws_route_table" "public-RT" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.frontend_igw.id}"
  }

  tags {
    Name = "balder_public_RT"
  }
}

# Backend

resource "aws_subnet" "private" {
  vpc_id                  = "${aws_vpc.main.id}"
  availability_zone       = "${element(var.azs, 1)}"
  cidr_block              = "${element(var.subnets_cidr, 1)}"
  map_public_ip_on_launch = false

  tags {
    Name = "${element(var.app, 1)}_subnet"
  }
}

resource "aws_route_table" "private_RT" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = "${aws_instance.nat_instance.id}"
  }

  tags {
    Name = "balder_private_RT"
  }

  depends_on = ["aws_instance.nat_instance"]
}

# Associate route table with public subnet to make the subnet public
resource "aws_route_table_association" "frontend" {
  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.public-RT.id}"
}

# Associate route table with private subnet to make the subnet private
resource "aws_route_table_association" "backend" {
  subnet_id      = "${aws_subnet.private.id}"
  route_table_id = "${aws_route_table.private_RT.id}"
}
