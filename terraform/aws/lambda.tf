data "aws_ecr_repository" "lambda_repo" {
  name = "ratingcurve-lambda"
}

resource "aws_lambda_function" "fit_rating" {
  function_name = "fit_rating"
  image_uri     = "${data.aws_ecr_repository.lambda_repo.repository_url}:${var.image_tag}"
  package_type  = "Image"
  role          = aws_iam_role.lambda_exec.arn

  timeout = 300
  memory_size = 1024
}

# IAM role which dictates what other AWS services the Lambda function
# may access.
resource "aws_iam_role" "lambda_exec" {
  name                 = "${var.bucket_name}_lambda_exec"
  permissions_boundary = var.permissions_boundary
  assume_role_policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fit_rating.function_name
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.api_gateway.execution_arn}/*/*"
}

