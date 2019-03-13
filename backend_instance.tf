data "aws_ami" "ubuntu-backend" {
  most_recent = true

  filter {
    name   = "name"
    values = ["backend-app"]
  }

  owners = ["097267457133"] # Canonical
}

resource "aws_instance" "backend" {
  # count = "${length(var.subnets_cidr)}"
  ami             = "${data.aws_ami.ubuntu-backend.id}"
  instance_type   = "${var.instance_type}"
  security_groups = ["${aws_security_group.webservers.id}"]
  subnet_id       = "${element(aws_subnet.public.*.id, 1)}"

  tags {
    Name = "backend"
  }
}

output "backend_ip" {
  value = "${aws_instance.backend.public_ip}"
}
