# Appliction VPC
resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr}"

  tags {
    Name = "balder_ah_vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "app_gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "balder_app_gateway"
  }
}

# Application Subnets for the VPC
resource "aws_subnet" "public" {
  count                   = "${length(var.subnets_cidr)}"
  vpc_id                  = "${aws_vpc.main.id}"
  availability_zone       = "${element(var.azs, count.index)}"
  cidr_block              = "${element(var.subnets_cidr, count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name = "${element(var.app, count.index)}_subnet"
  }
}

# Create Route table, attach internet gateway and associate with public subnet
resource "aws_route_table" "public-RT" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.app_gw.id}"
  }

  tags {
    Name = "balder_public_RT"
  }
}

resource "aws_subnet" "private" {
  vpc_id                  = "${aws_vpc.main.id}"
  availability_zone       = "${element(var.azs, 1)}"
  cidr_block              = "10.20.5.0/24"
  map_public_ip_on_launch = false

  tags {
    Name = "db_subnet"
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

# Attach route table with public subnets
resource "aws_route_table_association" "name" {
  count          = "${length(var.subnets_cidr)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public-RT.id}"
}

resource "aws_route_table_association" "db" {
  subnet_id      = "${aws_subnet.private.id}"
  route_table_id = "${aws_route_table.private_RT.id}"
}
