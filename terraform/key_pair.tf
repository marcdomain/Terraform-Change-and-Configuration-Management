resource "aws_key_pair" "ec2key" {
  key_name = "tf_publicKey"
  public_key = "${file(var.public_key_path)}"
}