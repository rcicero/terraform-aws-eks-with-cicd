// Code Build ROLE
resource "aws_iam_role" "role" {
    name = "CodeBuildKubectlRole"
    assume_role_policy = <<EOF
{ 
	"Version": "2012-10-17", 
	"Statement": [ 
		{ 
			"Effect": "Allow",
			"Principal": { "AWS": "arn:aws:iam::410017455363:root" },
			"Action": "sts:AssumeRole" 
		} 
	] 
}
EOF
    force_detach_policies = true
}


resource "aws_iam_policy" "policy" {
  name        = "eks-describe"
  path        = "/"
  description = "eks-describe"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "eks:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}


resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}

#CodePipeline Role
data "aws_iam_policy_document" "APP_CP_ASSUME_ROLE" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

// CODE PIPELINE ROLE
resource "aws_iam_role" "APP_ROLE_CP" {
  name               = "eks-codepipeline-role"
  assume_role_policy = data.aws_iam_policy_document.APP_CP_ASSUME_ROLE.json
}