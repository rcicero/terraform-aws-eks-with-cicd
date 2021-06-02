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

resource "aws_s3_bucket" "example2" {
  bucket = "example129292897282"
  acl    = "private"
}

resource "aws_codestarconnections_connection" "example" {
  name          = "example-connection"
  provider_type = "GitHub"
}

resource "aws_codepipeline" "APP_CODE_PIPELINE" {
  name     = "${var.environment}-teste"
  role_arn = "${aws_iam_role.APP_ROLE_CP.arn}"

  artifact_store {
    location = "${aws_s3_bucket.example2.bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.example.arn
        FullRepositoryId = "my-organization/example"
        BranchName       = "main"
      }
    }
  }
 
  stage {
    name = "Deploy"

    action {
      name             = "Test"
      category         = "Test"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source"]
      output_artifacts = ["tested"]
      version          = "1"

      configuration = {
        ProjectName = "${aws_codebuild_project.example.name}"
      }
    }
  }

 /* stage {
    name = "Test"

    action {
      name             = "Test"
      category         = "Test"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source"]
      output_artifacts = ["tested"]
      version          = "1"

      configuration = {
        ProjectName = "${aws_codebuild_project.test_project.name}"
      }
    }
  }

  stage {
    name = "Package"

    action {
      name             = "Package"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["tested"]
      output_artifacts = ["packaged"]
      version          = "1"

      configuration = {
        ProjectName = "${aws_codebuild_project.build_project.name}"
      }
    }
  }*/
}