output "eks_worker_nodes_001_lc_id" {
  value = "${aws_launch_configuration.eks_worker_nodes_001_lc.id}"
}

output "eks_worker_nodes_001_lc_name" {
  value = "${aws_launch_configuration.eks_worker_nodes_001_lc.name}"
}

output "eks_worker_nodes_001_asg_id" {
  value = "${aws_autoscaling_group.eks_worker_nodes_asg_001.id}"
}

output "eks_worker_nodes_001_asg_name" {
  value = "${aws_autoscaling_group.eks_worker_nodes_asg_001.name}"
}
