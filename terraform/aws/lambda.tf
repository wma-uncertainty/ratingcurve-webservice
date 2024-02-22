# zip the lamda function
data "archive_file" "source" {
  type        = "zip"
  source_dir  = "../../lambda-functions/fit_rating"
  output_path = "../../lambda-functions/fit_rating.zip"
}

# upload zip to s3
#resource "aws_s3_object" "lambda_upload" {
#  bucket = aws_s3_bucket.website.id
#  key    = "lambdas/fit_rating.zip"
#  source = data.archive_file.source.output_path
#  etag   = filemd5(data.archive_file.source.output_path)
#}

resource "aws_lambda_function" "fit_rating" {
  function_name    = "fit_rating"
  filename         = data.archive_file.source.output_path
  source_code_hash = filemd5(data.archive_file.source.output_path)

  handler = "fit_rating.main"
  runtime = "python3.11"
  role    = aws_iam_role.lambda_exec.arn
  layers  = [aws_lambda_layer_version.layer.arn]
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

# create python lamda layer from requirements.txt
resource "null_resource" "pip_install" {
  triggers = {
    shell_hash = "${filesha256("${path.module}/requirements.txt")}"
  }

  provisioner "local-exec" {
    command = "python3 -m pip install -r requirements.txt -t ${path.module}/layer"
  }
}

data "archive_file" "layer" {
  type        = "zip"
  source_dir  = "${path.module}/layer"
  output_path = "${path.module}/layer.zip"
  depends_on  = [null_resource.pip_install]
}

resource "aws_lambda_layer_version" "layer" {
  layer_name          = "ratingcurve-env"
  filename            = data.archive_file.layer.output_path
  source_code_hash    = data.archive_file.layer.output_base64sha256
  compatible_runtimes = ["python3.10", "python3.11", "python3.12"]
}
