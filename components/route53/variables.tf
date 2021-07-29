variable "aws_profile" {
  description = "The AWS profile from the credentials file that will be used to deploy this solution."
  default     = "default"
  type        = string
}

variable "aws_region" {
  description = "The AWS region the solution will be deployed to"
  type        = string
  default     = "eu-west-2"
}

variable "interval" {
  description = "The interval, in minutes, of the scheduled backup."
  type        = string
  default     = "120"
}

variable "retention_period" {
  description = "The time, in days, the backup is stored for"
  type        = string
  default     = "14"
}

variable "enable_versioning" {
  description = "The time, in days, the backup is stored for"
  type        = bool
  default     = "true"
}

variable "environment" {
#  description = "The time, in days, the backup is stored for"
  type        = string
}

variable "project" {
#  description = "The time, in days, the backup is stored for"
  type        = string
  default     = "nhsdc19"
}

variable "component" {
#  description = "The time, in days, the backup is stored for"
  type        = string
  default     = "route53"
}

variable "alias" {
  type        = string
  description = "The display name of the alias for the hieradata KMS key. The name must start with the word 'alias' followed by a forward slash"
  default = "alias/route53-key"
}