data "aws_ami" "frontend" {
  most_recent = true

  filter {
    name   = "name"
    values = ["frontend-app"]
  }

  owners = ["097267457133"] # Canonical
}

resource "aws_instance" "frontend" {
  ami             = "${data.aws_ami.frontend.id}"
  key_name        = "${aws_key_pair.ec2key.key_name}"
  instance_type   = "${var.instance_type}"
  security_groups = ["${aws_security_group.webservers.id}"]
  subnet_id       = "${aws_subnet.public.id}"

  tags {
    Name = "frontend"
  }
}

output "frontend_ip" {
  value = "${aws_instance.frontend.public_ip}"
}
