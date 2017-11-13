output "cluster_name" {
  value = "${var.cluster_name}"
}

output "aws_cidr_block" {
  value = "${aws_vpc.default.cidr_block}"
}

output "aws_vpc_id" {
  value = "${aws_vpc.default.id}"
}

output "aws_azs" {
  value = "${var.aws_azs}"
}

output "aws_dns_zone_id" {
  value = "${aws_route53_zone.private.zone_id}"
}

output "kops_state_store" {
  value = "${var.kops_state_store}"
}

output "aws_region" {
  value = "${var.aws_region}"
}

output "gpu_image_name" {
  value = "${data.aws_ami.gpu.name}"
}

output "gpu_image_location" {
  value = "${data.aws_ami.gpu.image_location}"
}

output "gpu_image_id" {
  value = "${data.aws_ami.gpu.id}"
}

output "coreos_image_name" {
  value = "${data.aws_ami.coreos.name}"
}

output "coreos_image_location" {
  value = "${data.aws_ami.coreos.image_location}"
}

output "coreos_image_id" {
  value = "${data.aws_ami.coreos.id}"
}

output "nfs_sg" {
  value = "${aws_security_group.nfs.id}"
}
