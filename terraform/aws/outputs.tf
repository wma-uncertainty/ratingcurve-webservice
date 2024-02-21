output "stage_url" {
  value = aws_api_gateway_stage.ratingcurve.invoke_url
}

# TODO remove hardcoded fit_rating
output "fit_rating_url" {
  value = "${aws_api_gateway_stage.ratingcurve.invoke_url}/fit_rating"
}
