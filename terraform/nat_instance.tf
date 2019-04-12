resource "aws_instance" "nat_instance" {
  ami             = "${var.nat_ami}"
  key_name        = "key_pair"
  instance_type   = "${var.instance_type}"
  security_groups = ["${aws_security_group.webservers.id}"]
  subnet_id       = "${element(aws_subnet.public.*.id, 1)}"

  tags {
    Name = "nat_instance"
  }
}
