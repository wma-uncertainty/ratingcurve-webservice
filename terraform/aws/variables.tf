variable "region" {
  type        = string
  description = <<-EOT
  AWS region to perform all our operations in.
  EOT
}

variable "aws_tags" {
  type        = map(string)
  default     = {}
  description = <<-EOT
  (Optional) AWS resource tags.
  EOT
}

variable "bucket_name" {
  type        = string
  description = <<-EOT
  Name of bucket to store website files.
  EOT
}

variable "permissions_boundary" {
  type        = string
  default     = null
  description = <<-EOT
  (Optional) ARN of the policy that is used to set the permissions boundary for
  the role.
  EOT
}

variable "upload_directory" {
  default     = "../../website/"
  description = <<-EOT
  Directory containing website files to upload to S3.
  EOT
}

variable "mime_types" {
  default = {
    htm  = "text/html"
    html = "text/html"
    css  = "text/css"
    svg  = "image/svg+xml"
    jpg  = "image/jpeg"
    jpeg = "image/jpeg"
    png  = "image/png"
    ttf  = "font/ttf"
    js   = "application/javascript"
    map  = "application/javascript"
    json = "application/json"
  }
  description = <<-EOT
  Allowed MIME types for website files.
  EOT
}
