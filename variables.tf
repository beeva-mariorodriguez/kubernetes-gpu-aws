variable "cluster_name" {
  type = "string"
}

variable "aws_region" {
  type    = "string"
  default = "us-east-2"
}

variable "aws_azs" {
  type    = "list"
  default = ["us-east-2a", "us-east-2b"]
}

variable "domain_name" {
  type = "string"
}

variable "kops_state_store" {
  type = "string"
}
