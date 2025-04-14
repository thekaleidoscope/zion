resource "aws_s3_bucket" "s3ntinel-vault" {
  bucket = "s3ntinel-vault"
  lifecycle {
    prevent_destroy = true
  }
}
