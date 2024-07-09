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

variable "eft_by_date" {
  type        = string
  default     = "by_date"
}

variable "eft_data_by_batch" {
  type        = string
  default     = "data_by_batch"
}

variable "eft_data_by_location" {
  type        = string
  default     = "data_by_location"
}

variable "eft_batch_detail" {
  type        = string
  default     = "batch_detail"
}

variable "eft_by_date_bucket_name" {
  type        = string
  default     = "by-date"
}

variable "eft_data_by_batch_bucket_name" {
  type        = string
  default     = "data-by-batch"
}

variable "eft_data_by_location_bucket_name" {
  type        = string
  default     = "data-by-location"
}

variable "eft_batch_detail_bucket_name" {
  type        = string
  default     = "batch-detail"
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