# Launch configuration
resource "aws_launch_configuration" "eks_worker_nodes_launch_configuration" {
  associate_public_ip_address = false
  image_id                    = "${var.image_id}"
  instance_type               = "${var.instance_type}"
  security_groups             = ["${aws_security_group.eks_cluster_security_group.id}"]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "eks_worker_nodes_autoscaling_group" {
  desired_capacity     = 2
  launch_configuration = "${aws_launch_configuration.eks_worker_nodes_launch_configuration.id}"
  max_size             = 2
  min_size             = 1
  termination_policies = [ "OldestLaunchConfiguration" ]
  vpc_zone_identifier  = ["${aws_subnet.eks_subnet.0.id}","${aws_subnet.eks_subnet.1.id}"]
}
