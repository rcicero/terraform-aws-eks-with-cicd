resource "aws_codepipeline" "pipeline" {
  name     = "teste-${var.environment}"
  role_arn = "aws_iam_role.APP_ROLE_CP.arn"

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = "arn:aws:codestar-connections:us-east-1:524945736758:connection/91a0eb07-5620-4e41-9984-b45bc1547380"
        FullRepositoryId = var.bitbucket_repository_name
        BranchName       = var.bitbucket_repository_branch
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["BuildArtifact"]

      configuration = {
        ProjectName = "crdc"
        EnvironmentVariables = file("${path.module}/envvars.json")
      }

     
    }
  }
}