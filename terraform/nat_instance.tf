resource "aws_instance" "nat_instance" {
  ami             = "${var.nat_ami}"
  key_name        = "${aws_key_pair.ec2key.key_name}"
  instance_type   = "${var.instance_type}"
  security_groups = ["${aws_security_group.webservers.id}"]
  subnet_id       = "${element(aws_subnet.public.*.id, 0)}"

  tags {
    Name = "nat_instance"
  }
}
