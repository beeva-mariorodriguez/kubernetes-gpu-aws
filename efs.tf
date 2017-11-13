resource "aws_subnet" "nfs" {
  vpc_id     = "${aws_vpc.default.id}"
  cidr_block = "10.20.100.0/24"
}

resource "aws_security_group" "nfs" {
  name   = "nfs"
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_security_group" "nfs_server" {
  name   = "nfs_server"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = ["${aws_security_group.nfs.id}"]
  }
}

resource "aws_efs_file_system" "data" {}
resource "aws_efs_file_system" "output" {}

resource "aws_efs_mount_target" "data" {
  file_system_id  = "${aws_efs_file_system.data.id}"
  subnet_id       = "${aws_subnet.nfs.id}"
  security_groups = ["${aws_security_group.nfs_server.id}"]
}

resource "aws_efs_mount_target" "output" {
  file_system_id  = "${aws_efs_file_system.output.id}"
  subnet_id       = "${aws_subnet.nfs.id}"
  security_groups = ["${aws_security_group.nfs_server.id}"]
}

resource "aws_route53_record" "data-nfs" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "data.nfs"
  type    = "A"
  ttl     = "300"
  records = ["${aws_efs_mount_target.data.ip_address}"]
}

resource "aws_route53_record" "output-nfs" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "output.nfs"
  type    = "A"
  ttl     = "300"
  records = ["${aws_efs_mount_target.output.ip_address}"]
}
