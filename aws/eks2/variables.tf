# AWS
variable "region" {
  type = "string"
  default = "eu-west-2"
}

# Cluster
variable "cluster_name" {
  type = "string"
  default = "cluster001"
}
variable "eks_version" {
  type = "string"
  default = "1.14"
}

# Worker Nodes
variable "image_id" {
  type = "string"
  default = "ami-0be057a22c63962cb"
}
variable "instance_type" {
  type = "string"
  default = "t2.micro"
}

# Tags
variable "tag" {
  type = "string"
  default = "EKS"
}
