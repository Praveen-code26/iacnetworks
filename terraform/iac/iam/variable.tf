#eu-east-2
# Account - "************"
variable "aws_region" {
  type        = string
  default     = "us-east-2"
}

variable "environment" {
    type    = string
    default = "IaaC"
}

variable "aws_account_id" {
  type        = string
  default     = ""
}

variable "app" {
  type        = string
  default     = ""
}



variable "app_bucket_name" {
  type        = string
  default     = ""
}


variable "ecs_task_execution_role_name" {
  type        = string
  default     = "ecsTaskExecutionRole"
}

variable "ecs_task_role_name" {
  type        = string
  default     = "ecsTaskRole"
}

variable "app_lambda_role_name" {
  type        = string
  default     = "lambdaRole"
}
