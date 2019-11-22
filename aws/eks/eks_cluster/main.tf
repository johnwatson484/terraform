# TERRAFORM CONFIG
terraform {
  backend "s3" {}
}

provider "aws" {
  version = ">= 1.2"
  region = "${var.region}"
}

# ACOUNT ID
data "aws_caller_identity" "current" {}

## SECURITY GROUP STATE
data "terraform_remote_state" "sgp_state" {
  backend = "s3"
  config {
    bucket = "johnwatsonaws1-eks-terraform-shared-state"
    key = "/${var.region}/${var.environment}/security_groups/terraform.tfstate"
    region = "${var.region}"
  }
}

## SUBNET STATE
data "terraform_remote_state" "sbn_state" {
  backend = "s3"
  config {
    bucket = "johnwatsonaws1-eks-terraform-shared-state"
    key = "/${var.region}/${var.environment}/subnets/terraform.tfstate"
    region = "${var.region}"
  }
}

# IAM GROUP STATE
data "terraform_remote_state" "iam_state" {
  backend = "s3"
  config {
    bucket = "johnwatsonaws1-eks-terraform-shared-state"
    key    = "/${var.region}/${var.environment}/iam/terraform.tfstate"
    region = "${var.region}"
  }
}

# EKS CLUSTER
resource "aws_eks_cluster" "eks_cluster_001" {
  depends_on = ["aws_cloudwatch_log_group.eks_cluster_log_group_001"]
  name = "${var.eks_cluster_001}"
  role_arn = "${data.terraform_remote_state.iam_state.eks_cluster_role_arn}"
  enabled_cluster_log_types = ["api", "audit"]
  version = "${var.eks_version}"
  vpc_config {
    security_group_ids = ["${data.terraform_remote_state.sgp_state.eks_cluster_sgp001}"]
    subnet_ids = ["${data.terraform_remote_state.sbn_state.int_a_sbn_1_id}", "${data.terraform_remote_state.sbn_state.int_b_sbn_1_id}", "${data.terraform_remote_state.sbn_state.int_c_sbn_1_id}"]
    endpoint_private_access = "true"
    endpoint_public_access = "false"
  }  
}

# CLOUDWATCH LOG GROUP
resource "aws_cloudwatch_log_group" "eks_cluster_log_group_001" {
  name = "${var.eks_cluster_name_001}-logs"
  retention_in_days = 1
  tags {
    Name = "${var.eks_cluster_name_001}-logs"
    Environment = "${var.env}"
    Project = "${var.service["code"]}"
    Region = "${var.region}"
    Tier = "APP"
    ServiceCode = "${var.service["code"]}"
    ServiceType = "${var.service["type"]}"
    ServiceName = "${var.service["name"]}"
    CreationDateTime = "${timestamp()}"
    Source = "Terraform Managed"
  }
}
