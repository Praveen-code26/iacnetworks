output "eft_by_date_bucket_name" {
  value = aws_s3_bucket.eft_by_date_bucket.id
}

output "eft_by_date_request_object_key" {
  value = aws_s3_object.eft_by_date_request_object.id
}

output "eft_by_date_call_365_response_object_key" {
  value = aws_s3_object.eft_by_date_call_365_response_object.id
}

output "eft_data_by_batch_bucket_name" {
  value = aws_s3_bucket.eft_data_by_batch_bucket.id
}

output "eft_data_by_batch_request_object_key" {
  value = aws_s3_object.eft_data_by_batch_request_object.id
}

output "eft_data_by_batch_transform_request_365_object_key" {
  value = aws_s3_object.eft_data_by_batch_transform_request_365_object.id
}

output "eft_data_by_batch_call_365_response_object_key" {
  value = aws_s3_object.eft_data_by_batch_call_365_response_object.id
}

output "eft_data_by_location_bucket_name" {
  value = aws_s3_bucket.eft_data_by_location_bucket.id
}

output "eft_data_by_location_request_object_key" {
  value = aws_s3_object.eft_data_by_location_request_object.id
}

output "eft_data_by_location_transform_request_365_object_key" {
  value = aws_s3_object.eft_data_by_location_transform_request_365_object.id
}

output "eft_data_by_location_call_365_response_object_key" {
  value = aws_s3_object.eft_data_by_location_call_365_response_object.id
}

output "eft_data_by_location_transform_response_365_object_key" {
  value = aws_s3_object.eft_data_by_location_transform_response_365_object.id
}

output "eft_batch_detail_bucket_name" {
  value = aws_s3_bucket.eft_batch_detail_bucket.id
}

output "eft_batch_detail_request_object_key" {
  value = aws_s3_object.eft_batch_detail_request_object.id
}

output "eft_batch_detail_transform_request_365_object_key" {
  value = aws_s3_object.eft_batch_detail_transform_request_365_object.id
}

output "eft_batch_detail_call_365_response_object_key" {
  value = aws_s3_object.eft_batch_detail_call_365_response_object.id
}
