output "eks_cluster_001_id" {
  value = "${aws_eks_cluster.eks_cluster_001.id}"
}

output "eks_cluster_001_arn" {
  value = "${aws_eks_cluster.eks_cluster_001.arn}"
}

output "eks_cluster_001_kubeconfig_certificate_authority_data" {
  value = "${aws_eks_cluster.eks_cluster_001.certificate_authority.0.data}"
}

output "eks_cluster_001_endpoint" {
  value = "${aws_eks_cluster.eks_cluster_001.eks_cluster_001_endpoint}"
}

output "eks_cluster_001_platform_version" {
  value = "${aws_eks_cluster.eks_cluster_001.platform_version}"
}

output "eks_cluster_001_version" {
  value = "${aws_eks_cluster.eks_cluster_001.version}"
}

output "eks_cluster_001_log_group" {
  value = "${aws_cloudwatch_log_group.eks_cluster_log_group_001.id}"
}
