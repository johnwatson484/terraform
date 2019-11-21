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

# IAM GROUP STATE
data "terraform_remote_state" "iam_state" {
  backend = "s3"
  config {
    bucket = "${data.aws_caller_identity.current.account_id}-${var.region}-${lower(var.service["code"])}-terraform-shared-state"
    key    = "/${var.region}/${var.environment}/iam/terraform.tfstate"
    region = "${var.region}"
  }
}

## K8S STATE 
data "terraform_remote_state" "k8s_state" {
  backend = "s3"
  config {
    bucket = "${data.aws_caller_identity.current.account_id}-${var.region}-${lower(var.service["code"])}-terraform-shared-state"
    key    = "/${var.region}/${var.environment}/eks_cluster/terraform.tfstate"
    region = "${var.region}"
  }
}

## SECURITY GROUP STATE
data "terraform_remote_state" "sgp_state" {

  backend = "s3"
  config {
    bucket = "${data.aws_caller_identity.current.account_id}-${var.region}-${lower(var.service["code"])}-terraform-shared-state"
    key    = "/${var.region}/${var.environment}/security_groups/terraform.tfstate"
    region = "${var.region}"
  }
}

## SUBNET STATE
data "terraform_remote_state" "sbn_state" {

  backend = "s3"
  config {
    bucket = "${data.aws_caller_identity.current.account_id}-${var.region}-${lower(var.service["code"])}-terraform-shared-state"
    key    = "/${var.region}/${var.environment}/subnets/terraform.tfstate"
    region = "${var.region}"
  }
}

# WORKER USER DATA
data "template_file" "eks_worker_userdata_001" {
  template = "${file("${path.module}/eks_worker_userdata.tpl")}"
  vars {
    hostname = "JWAWS1CLUSTER001"
    eks_jenkins_cluster_endpoint = "${data.terraform_remote_state.eks_cluster_001_endpoint}"
    eks_jenkins_cluster_kubeconfig_certificate_authority_data = "${data.terraform_remote_state.eks_cluster_001_kubeconfig_certificate_authority_data}"
    eks_cluster_name = "${var.eks_cluster_name_001}"
  }
}

# WORKER NODE RESOURCES
#  * IAM role allowing Kubernetes actions to access other AWS services
#  * EC2 Security Group to allow networking traffic
#  * Data source to fetch latest EKS worker AMI
#  * AutoScaling Launch Configuration to configure worker instances
#  * AutoScaling Group to launch worker instances

# LAUNCH CONFIGURATION
resource "aws_launch_configuration" "eks_worker_nodes_001_lc" {
  associate_public_ip_address = false
  iam_instance_profile = "${data.terraform_remote_state.iam_state.eks_worker_node_profile_arn}"
  image_id = "${var.eks_worker_ami_id}"
  instance_type = "t2.micro"
  user_data = "${data.template_file.eks_worker_userdata_001.rendered}"
  name_prefix = "JWAWS1CLUSTERLC001"
  security_groups = ["${data.terraform_remote_state.sgp_state.eks_cluster_nodes_sgp001}"]
  key_name = "${var.env}${var.loc}${var.service["code"]}KPR001"
  lifecycle {
    create_before_destroy = true
  }
}

# AUTO SCALING GROUP
resource "aws_autoscaling_group" "eks_worker_nodes_asg_001" {
  desired_capacity = 3
  launch_configuration = "${aws_launch_configuration.eks_worker_nodes_001_lc.id}"
  max_size = 3
  min_size = 1
  termination_policies = ["OldestLaunchConfiguration"]
  name = "JWAWS1CLUSTERASG001"
  vpc_zone_identifier = ["${data.terraform_remote_state.sbn_state.int_a_sbn_1_id}", "${data.terraform_remote_state.sbn_state.int_b_sbn_1_id}", "${data.terraform_remote_state.sbn_state.int_c_sbn_1_id}"]
  tag {
    key = "Name"
    value = "${var.env}${var.service["code"]}SRV001"
    propagate_at_launch = true
  }
  tag {
    key = "Environment"
    value = "${var.env}"
    propagate_at_launch = true
  }
  tag {
    key                 = "Environment"
    value               = "${var.env}"
    propagate_at_launch = true
  }
  tag {
    key                 = "ServiceCode"
    value               = "${var.service["code"]}"
    propagate_at_launch = true
  }
  tag {
    key                 = "ServiceType"
    value               = "${var.service["type"]}"
    propagate_at_launch = true
  }
  tag {
    key                 = "ServiceName"
    value               = "${var.service["name"]}"
    propagate_at_launch = true
  }
  tag {
    key                 = "Region"
    value               = "${var.region}"
    propagate_at_launch = true
  }
  tag {
    key                 = "Location"
    value               = "${var.location}"
    propagate_at_launch = true
  }
  tag {
    key                 = "Tier"
    value               = "APS"
    propagate_at_launch = true
  }
  tag {
    key                 = "Project"
    value               = "${var.service["name"]}"
    propagate_at_launch = true
  }
  tag {
    key                 = "Source"
    value               = "Terraform managed"
    propagate_at_launch = true
  }
  tag {
    key                 = "kubernetes.io/cluster/${var.eks_cluster_name_001}"
    value               = "owned"
    propagate_at_launch = true
  }
}
