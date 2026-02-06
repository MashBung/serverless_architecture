resource "aws_s3_bucket" "image_storage" {
    bucket = "your-bucketname-${random_id.bucket_suffix.hex}"
}

resource "random_id" "bucket_suffix" {
    byte_length = 4
}

/*resource "aws_s3_bucket_notification" "bucket_notification"{
    bucket = aws_s3_bucket.image_storage.id

    lambda_function{
        lambda_function_arn = your-arn
        events = ["s3:ObjectCreated:*"]
        filter_prefix = "yourpath/"
    }
    depends_on = [aws_lambda_permission.allow_s3]
}*/