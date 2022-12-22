data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/"
  output_path = "lambda/index.zip"
}            