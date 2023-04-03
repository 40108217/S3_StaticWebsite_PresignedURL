output "bucket_endpoint" {
  description = "Bucket endpoint"
  value       = aws_s3_bucket.dynamic_bucket.id
}