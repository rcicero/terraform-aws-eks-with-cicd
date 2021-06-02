variable "region" {
  default     = "us-east-1"
  description = "AWS region"
}

variable "environment" {
	type = string
	default = "dev"
}

variable "bitbucket_repository_name" {
	type = string
	default = "dev"
}

variable "bitbucket_repository_branch" {
	type = string
	default = "dev"
}

variable "project_name"{
	type = string
	default = "meuteste9218"
}

variable "vpc_name"{
	type = string
	default = "minhavpc123"
}

variable "vpc_cidr"{
	type = string
	default = "10.167.0.0/16"
}

variable "vpc_subnet_private"{
	type = list
	default = ["10.167.1.0/24", "10.167.2.0/24", "10.167.3.0/24"]
}


