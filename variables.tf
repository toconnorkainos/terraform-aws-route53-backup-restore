variable "project" {
  type        = string
  description = "The Project name"
}

variable "environment" {
  type        = string
  description = "The environment name"
}

variable "component" {
  type        = string
  description = "The TF component name"
  default     = "cdoc"
}

variable "interval" {
  description = "The interval, in minutes, of the scheduled backup."
  type        = string
  default     = "120"
}


variable "s3_bucket_name" {
  description = "Name of the s3 bucket to back up into"
  type        = string
}
