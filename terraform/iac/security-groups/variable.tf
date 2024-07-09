#"eu-west-2"
variable "environment" {
    type    = string
    default = "eft"
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
}

variable "alb_sg_name" {
  type        = string
  default     = "sg-alb"
}

variable "ecs_sg_name" {
  type        = string
  default     = "sg-ecs-tasks"
}