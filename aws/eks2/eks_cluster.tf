# AWS Account ID
data "aws_caller_identity" "current" {}

# Cluster IAM Role
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks_cluster_role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.eks_cluster_role.name}"
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.eks_cluster_role.name}"
}

# Security Group
resource "aws_security_group" "eks_cluster_security_group" {
  name        = "eks_cluster_security_group"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${aws_vpc.eks_vpc.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.tag}"
  }
}

# Allow access to cluster from local workstation using workstation_external_ip_tf values
resource "aws_security_group_rule" "eks-cluster-ingress-workstation-https" {
  cidr_blocks       = ["${local.workstation-external-cidr}"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.eks_cluster_security_group.id}"
  to_port           = 443
  type              = "ingress"
}

# EKS Cluster
resource "aws_eks_cluster" "eks_cluster_001" {
  name = "${var.cluster_name}"
  role_arn = "${aws_iam_role.eks_cluster_role.arn}"
  version = "${var.eks_version}"
  vpc_config {
    security_group_ids = ["${aws_security_group.eks_cluster_security_group.id}"]
    subnet_ids = ["${aws_subnet.eks_subnet.0.id}","${aws_subnet.eks_subnet.1.id}"]
    endpoint_private_access = "true"
    endpoint_public_access = "true"
  }
}

