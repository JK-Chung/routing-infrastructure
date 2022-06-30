variable "fqdn" {
  type        = string
  description = "The FQDN of the service that we're creating an ALB target group and ALB listener for."
}

variable "project" {
  type        = string
  description = "The project name for the target group we're creating"
}

variable "application" {
  type        = string
  description = "The application name for the target group we're creating"
}

variable "target_group_target_type" {
  type        = string
  description = "The target type for the created target group"

  validation {
    condition     = contains(["ip", "lambda", "instance"], var.target_group_target_type)
    error_message = "Valid values for var.target_group_target_type are [\"ip\",\"lambda\",\"instance\"]."
  }
}

variable "vpc_id" {
  type        = string
  description = "The VPC IP of the ALB"
}

variable "alb_listener_arn" {
  type        = string
  description = "The ARN of the ALB listener we're using to handle all of our hosts"
}