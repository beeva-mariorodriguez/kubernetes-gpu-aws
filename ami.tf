data "aws_ami" "coreos" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["CoreOS-stable-*"]
  }
}

data "aws_ami" "gpu" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["beevalabs-docker-nvidia-*"]
  }
}
