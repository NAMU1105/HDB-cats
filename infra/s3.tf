resource "aws_s3_bucket" "cat_photos" {
  bucket = "hdb-cat-photos-bucket"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.cat_photos.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = "*",
      Action = "s3:GetObject",
      Resource = "${aws_s3_bucket.cat_photos.arn}/*"
    }]
  })
}
