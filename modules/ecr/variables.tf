variable "name" {
  description = "name of repository"
}

variable "image_tag_mutability" {
  default     = "MUTABLE"
  description = "The tag mutability setting for the repository"
}

variable "scan_on_push" {
  default = true
}

variable "enable_lifecycle_policy" {
  description = "Enabled or disabled ECR repository lifecycle policy."
  default     = true
}

