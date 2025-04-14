resource "aws_s3_bucket" "matrix-blobsmith" {
  bucket = "matrix-blobsmith"
  lifecycle {
    prevent_destroy = true
  }
}
