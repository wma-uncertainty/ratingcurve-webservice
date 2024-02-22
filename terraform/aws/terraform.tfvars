region = "us-west-2"

bucket_name = "ratingcurve-webservice"

aws_tags = {
  "wma:project_id"     = "uncertainty_ts"
  "wma:application_id" = "ratingcurve_webservice"
  "wma:contact"        = "thodson@usgs.gov"
}

permissions_boundary = "arn:aws:iam::807615458658:policy/csr-Developer-Permissions-Boundary"

image_tag = "0.0.1"
