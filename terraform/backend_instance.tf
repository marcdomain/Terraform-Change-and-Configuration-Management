data "aws_ami" "backend" {
  most_recent = true

  filter {
    name   = "name"
    values = ["backend-app"]
  }

  owners = ["097267457133"] # Canonical
}

resource "aws_instance" "backend" {
  ami             = "${data.aws_ami.backend.id}"
  key_name        = "${aws_key_pair.ec2key.key_name}"
  instance_type   = "${var.instance_type}"
  security_groups = ["${aws_security_group.backend.id}"]
  subnet_id       = "${aws_subnet.private.id}"

  tags {
    Name = "backend"
  }
}

output "backend_ip" {
  value = "${aws_instance.backend.public_ip}"
}
