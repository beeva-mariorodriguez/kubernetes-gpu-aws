# can only declare a provider once, but it's needed by both main.tf and the kops generated kubernetes.tf
provider "aws" {
  region = "${var.aws_region}"
}
