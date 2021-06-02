resource "kubernetes_config_map" "aws_auth" {
	metadata {
		name = "aws-auth"
	}
	data = {
        "mapRoles"    = <<-EOT
            - rolearn: arn:aws:iam::410017455363:policy/eks-describe
              username: build
              groups:
              - system:masters
       
        EOT
    }
}