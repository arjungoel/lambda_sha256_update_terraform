resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "terraform-jenkins-lambda-layer-bucket"
  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_object" "file_upload" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "lambda/index.zip"
  source = data.archive_file.lambda_zip.output_path # its mean it depended on zip
  etag   = filemd5(data.archive_file.lambda_zip.output_path)
}