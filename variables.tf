variable "interval" {
  description = "The interval, in minutes, of the scheduled backup."
  type        = string
  default     = "120"
}

variable "s3_bucket_name" {
  description = "Name of the s3 bucket to back up into"
  type        = string
}


variable "tags" {
  description = "(Optional) A mapping of tags to assign to the module."
  type        = map(string)
  default     = {}
}
