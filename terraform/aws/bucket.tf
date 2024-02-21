resource "aws_s3_bucket" "website" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_ownership_controls" "website" {
  bucket = aws_s3_bucket.website.id
  rule {
    #object_ownership = "BucketOwnerPreferred"
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#resource "aws_s3_bucket_acl" "website" {
#  depends_on = [
#    aws_s3_bucket_ownership_controls.website,
#    aws_s3_bucket_public_access_block.website,
#  ]
#
#  bucket = aws_s3_bucket.website.id
#  acl    = "public-read"
#}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_object" "website_files" {
  for_each = fileset(var.upload_directory, "**/*.*")
  bucket   = aws_s3_bucket.website.id
  key      = replace(each.value, var.upload_directory, "")
  source   = "${var.upload_directory}${each.value}"
  #acl          = "public-read"
  etag         = filemd5("${var.upload_directory}${each.value}")
  content_type = lookup(var.mime_types, split(".", each.value)[length(split(".", each.value)) - 1])
}
