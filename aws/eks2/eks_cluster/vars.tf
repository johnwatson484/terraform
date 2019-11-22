variable "eks_cluster_name_001" {
  description = "EKS cluster name"
}

variable "service" {
  type = "map"
  description = "Map of service details, Name, Type and Code"
}

variable "region" {
  type = "string"
  description = "AWS region, eg. eu-west-2"
}

variable "env" {
  type = "string"
  description = "Three letter environment descriptor, eg. DEV, TST, PRD"
}

variable "environment" {
  type = "string"
  description = "Environment used in the terragrunt directory structure"
}

variable "eks_version" {
  type = "string"
  description = "Version of EKS cluster"
}

