data "aws_ami" "ubuntu-frontend" {
  most_recent = true

  filter {
    name   = "name"
    values = ["frontend-app"]
  }

  owners = ["097267457133"] # Canonical
}

resource "aws_instance" "frontend" {
  ami             = "${data.aws_ami.ubuntu-frontend.id}"
  key_name        = "key_pair"
  instance_type   = "${var.instance_type}"
  security_groups = ["${aws_security_group.webservers.id}"]
  subnet_id       = "${element(aws_subnet.public.*.id, 0)}"

  tags {
    Name = "frontend"
  }
}

output "frontend_ip" {
  value = "${aws_instance.frontend.public_ip}"
}
