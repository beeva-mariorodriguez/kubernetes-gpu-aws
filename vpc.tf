resource "aws_vpc" "default" {
  cidr_block           = "10.20.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "default" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.20.200.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route" "r" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = "${aws_vpc.default.default_route_table_id}"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

resource "aws_route53_zone" "private" {
  name          = "${var.domain_name}"
  force_destroy = true
  vpc_id        = "${aws_vpc.default.id}"
}
