#eu-west-2
#"030574150512"
variable "aws_region" {
  type        = string
  default     = "us-east-1"
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
  default     = "by_date"
}



variable "app_bucket_name" {
  type        = string
  default     = "by-date"
}


variable "ecs_task_execution_role_name" {
  type        = string
  default     = "ecsTaskExecutionRole"
}

variable "ecs_task_role_name" {
  type        = string
  default     = "ecsTaskRole"
}

variable "eft_lambda_role_name" {
  type        = string
  default     = "lambdaRole"
}
