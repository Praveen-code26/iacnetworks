variable "aws_region" {
  type        = string
  default     = "eu-west-2"
}

variable "bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique."
  type        = string
  default     = "IaaC-terraformstate"
}

variable "table_name" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        = string
  default     = "IaaC-terraform-state-locks"
}