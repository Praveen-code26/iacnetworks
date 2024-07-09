terraform {

  backend "s3" {
    bucket         = "IaaC-terraformstate"
    key            = "IaaC/iam/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "IaaC-terraform-state-locks"
    encrypt        = true
  }

  required_version = "~> 1.3.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "${var.aws_region}"

  default_tags {
    tags = {
      Environment = "${var.environment}"
      DeployedBy  = "Terraform"
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.environment}_${var.ecs_task_execution_role_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.environment}_${var.ecs_task_role_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_policy" "eft_by_date_task_policy" {
  name        = "${var.environment}_${var.eft_by_date}_task_policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sqs:ReceiveMessage",
                "sqs:DeleteMessage",
                "sqs:GetQueueAttributes",
                "sqs:DeleteMessageBatch",
                "sqs:SendMessage",
                "s3:PutObject",
				        "s3:GetObject",
				        "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:sqs:${var.aws_region}:${var.aws_account_id}:${var.environment}_${var.eft_by_date}*",
                "arn:aws:s3:::${var.environment}-${var.eft_by_date_bucket_name}*"
            ]
        }
    ]
}
EOF

}

resource "aws_iam_policy" "eft_data_by_batch_task_policy" {
  name        = "${var.environment}_${var.eft_data_by_batch}_task_policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sqs:ReceiveMessage",
                "sqs:DeleteMessage",
                "sqs:GetQueueAttributes",
                "sqs:DeleteMessageBatch",
                "sqs:SendMessage",
                "s3:PutObject",
				        "s3:GetObject",
				        "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:sqs:${var.aws_region}:${var.aws_account_id}:${var.environment}_${var.eft_data_by_batch}*",
                "arn:aws:s3:::${var.environment}-${var.eft_data_by_batch_bucket_name}*"
            ]
        }
    ]
}
EOF

}

resource "aws_iam_policy" "eft_data_by_location_task_policy" {
  name        = "${var.environment}_${var.eft_data_by_location}_task_policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sqs:ReceiveMessage",
                "sqs:DeleteMessage",
                "sqs:GetQueueAttributes",
                "sqs:DeleteMessageBatch",
                "sqs:SendMessage",
                "s3:PutObject",
				        "s3:GetObject",
				        "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:sqs:${var.aws_region}:${var.aws_account_id}:${var.environment}_${var.eft_data_by_location}*",
                "arn:aws:s3:::${var.environment}-${var.eft_data_by_location_bucket_name}*"
            ]
        }
    ]
}
EOF

}

resource "aws_iam_policy" "eft_batch_detail_task_policy" {
  name        = "${var.environment}_${var.eft_batch_detail}_task_policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sqs:ReceiveMessage",
                "sqs:DeleteMessage",
                "sqs:GetQueueAttributes",
                "sqs:DeleteMessageBatch",
                "sqs:SendMessage",
                "s3:PutObject",
				        "s3:GetObject",
				        "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:sqs:${var.aws_region}:${var.aws_account_id}:${var.environment}_${var.eft_batch_detail}*",
                "arn:aws:s3:::${var.environment}-${var.eft_batch_detail_bucket_name}*"
            ]
        }
    ]
}
EOF

}

resource "aws_iam_role" "eft_lambda_role" {
  name = "${var.environment}_${var.eft_lambda_role_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_policy" "eft_by_date_lambda_policy" {
  name        = "${var.environment}_${var.eft_by_date}_lambda_policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sqs:ReceiveMessage",
                "sqs:DeleteMessage",
                "sqs:GetQueueAttributes",
                "sqs:DeleteMessageBatch",
                "sqs:SendMessage",
                "s3:PutObject",
				        "s3:GetObject",
				        "s3:DeleteObject",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:sqs:${var.aws_region}:${var.aws_account_id}:${var.environment}_${var.eft_by_date}*",
                "arn:aws:s3:::${var.environment}-${var.eft_by_date_bucket_name}*",
                "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:/aws/lambda/${var.environment}_${var.eft_by_date}*"
            ]
        }
    ]
}
EOF

}

resource "aws_iam_policy" "eft_data_by_batch_lambda_policy" {
  name        = "${var.environment}_${var.eft_data_by_batch}_lambda_policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sqs:ReceiveMessage",
                "sqs:DeleteMessage",
                "sqs:GetQueueAttributes",
                "sqs:DeleteMessageBatch",
                "sqs:SendMessage",
                "s3:PutObject",
				        "s3:GetObject",
				        "s3:DeleteObject",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:sqs:${var.aws_region}:${var.aws_account_id}:${var.environment}_${var.eft_data_by_batch}*",
                "arn:aws:s3:::${var.environment}-${var.eft_data_by_batch_bucket_name}*",
                "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:/aws/lambda/${var.environment}_${var.eft_data_by_batch}*"
            ]
        }
    ]
}
EOF

}

resource "aws_iam_policy" "eft_data_by_location_lambda_policy" {
  name        = "${var.environment}_${var.eft_data_by_location}_lambda_policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sqs:ReceiveMessage",
                "sqs:DeleteMessage",
                "sqs:GetQueueAttributes",
                "sqs:DeleteMessageBatch",
                "sqs:SendMessage",
                "s3:PutObject",
				        "s3:GetObject",
				        "s3:DeleteObject",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:sqs:${var.aws_region}:${var.aws_account_id}:${var.environment}_${var.eft_data_by_location}*",
                "arn:aws:s3:::${var.environment}-${var.eft_data_by_location_bucket_name}*",
                "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:/aws/lambda/${var.environment}_${var.eft_data_by_location}*"
            ]
        }
    ]
}
EOF

}

resource "aws_iam_policy" "eft_batch_detail_lambda_policy" {
  name        = "${var.environment}_${var.eft_batch_detail}_lambda_policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sqs:ReceiveMessage",
                "sqs:DeleteMessage",
                "sqs:GetQueueAttributes",
                "sqs:DeleteMessageBatch",
                "sqs:SendMessage",
                "s3:PutObject",
				        "s3:GetObject",
				        "s3:DeleteObject",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:sqs:${var.aws_region}:${var.aws_account_id}:${var.environment}_${var.eft_batch_detail}*",
                "arn:aws:s3:::${var.environment}-${var.eft_batch_detail_bucket_name}*",
                "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:/aws/lambda/${var.environment}_${var.eft_batch_detail}*"
                
            ]
        }
    ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "eft_by_date_task_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.eft_by_date_task_policy.arn
}

resource "aws_iam_role_policy_attachment" "eft_data_by_batch_task_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.eft_data_by_batch_task_policy.arn
}

resource "aws_iam_role_policy_attachment" "eft_data_by_location_task_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.eft_data_by_location_task_policy.arn
}

resource "aws_iam_role_policy_attachment" "eft_batch_detail_task_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.eft_batch_detail_task_policy.arn
}

resource "aws_iam_role_policy_attachment" "eft_by_date_lambda_policy_attachment" {
  role       = aws_iam_role.eft_lambda_role.name
  policy_arn = aws_iam_policy.eft_by_date_lambda_policy.arn
}

resource "aws_iam_role_policy_attachment" "eft_data_by_batch_lambda_policy_attachment" {
  role       = aws_iam_role.eft_lambda_role.name
  policy_arn = aws_iam_policy.eft_data_by_batch_lambda_policy.arn
}

resource "aws_iam_role_policy_attachment" "eft_data_by_location_lambda_policy" {
  role       = aws_iam_role.eft_lambda_role.name
  policy_arn = aws_iam_policy.eft_data_by_location_lambda_policy.arn
}

resource "aws_iam_role_policy_attachment" "eft_batch_detail_lambda_policy" {
  role       = aws_iam_role.eft_lambda_role.name
  policy_arn = aws_iam_policy.eft_batch_detail_lambda_policy.arn
}
