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

variable "k8s_networking" {
  type    = "string"
  default = "calico"
}

variable "k8s_version" {
  type    = "string"
  default = "1.8.0"
}

variable "k8s_node_size" {
  type    = "string"
  default = "t2.medium"
}
