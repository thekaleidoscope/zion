resource "aws_s3_bucket" "morpheus-dumps" {
  bucket = "morpheus-dumps"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_security_group" "sec_1" {
  description = "Security group for Morpheus dumps"
  vpc_id      = "vpc-0a1b2c3d4e5f6g7h8"
}
