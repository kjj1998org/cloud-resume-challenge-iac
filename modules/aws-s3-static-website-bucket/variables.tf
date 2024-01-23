# Input variable definitions

variable "bucket_name" {
  description = "Name of the s3 bucket. Must be unique."
  type        = string
}

variable "tags" {
  description = "Tags to set on the bucket."
  type        = map(string)
  default     = {}
}

variable "s3_bucket_object_ownership" {
  description = "Bucket object ownership scheme"
  type        = string
  default     = "BucketOwnerEnforced"
}

variable "s3_bucket_sse_algorithm" {
  description = "The encryption algorithm used for bucket server side encryption"
  type        = string
  default     = "AES256"
}

