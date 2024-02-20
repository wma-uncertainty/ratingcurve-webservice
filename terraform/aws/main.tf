provider "aws" {
  region = "us-west-2"  # Replace with your desired region
  default_tags {
    tags = {
      "wma:project_id" = "uncertainty-ts"
      "wma:application_id" = "ratingcurve-webservice"
      "wma:contact"    = "thodson@usgs.gov"
   }
 }
}

resource "aws_api_gateway_rest_api" "api_gateway" {
  name        = "ratingcurve-api"
  description = "API Gateway for rating curve demo"
}

resource "aws_api_gateway_resource" "api_gateway_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = "ratingcurve-demo"
}
