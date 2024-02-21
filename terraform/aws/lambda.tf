# zip the lamda function
data "archive_file" "source" {
  type        = "zip"
  source_dir  = "../../lambda-functions/fit-rating"
  output_path = "../../lambda-functions/fit-rating.zip"
}

# upload zip to s3
resource "aws_s3_bucket_object" "file_upload" {
  bucket = aws_s3_bucket.website.id
  key    = "lambdas/fit-rating.zip"
  source = data.archive_file.source.output_path
}

resource "aws_lambda_function" "fit_rating" {
  function_name = "fit-rating"

  # The bucket name as created earlier with "aws s3api create-bucket"
  s3_bucket = aws_s3_bucket.website.id
  s3_key    = "lambdas/fit-rating.zip"

  # "main" is the filename within the zip file (main.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  handler = "main.handler"
  runtime = "nodejs8.10"

  role = aws_iam_role.lambda_exec.arn
}

# IAM role which dictates what other AWS services the Lambda function
# may access.
resource "aws_iam_role" "lambda_exec" {
  name = "${var.bucket_name}_lambda_exec"

  assume_role_policy = <<EOF
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
