data "aws_ami" "database" {
  most_recent = true

  filter {
    name   = "name"
    values = ["app-database"]
  }

  owners = ["097267457133"] # Canonical
}

resource "aws_instance" "db_instance" {
  ami             = "${data.aws_ami.database.id}"
  key_name        = "key_pair"
  instance_type   = "${var.instance_type}"
  security_groups = ["${aws_security_group.database.id}"]
  subnet_id       = "${aws_subnet.private.id}"

  tags {
    Name = "db_instance"
  }
}
