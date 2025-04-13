resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy_attachment" "lambda_logs" {
  name       = "lambda_logs"
  roles      = [aws_iam_role.lambda_exec_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "upload_photo" {
  function_name = "uploadPhotoFunction"
  filename      = "lambda_upload_photo.zip"
  handler       = "uploadPhoto.handler"
  runtime       = "nodejs18.x"
  role          = aws_iam_role.lambda_exec_role.arn
  source_code_hash = filebase64sha256("lambda_upload_photo.zip")

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.cat_photos.bucket
      TABLE_NAME  = aws_dynamodb_table.cat_metadata.name
    }
  }
}

resource "aws_lambda_function" "get_photos" {
  function_name = "getPhotosFunction"
  filename      = "lambda_get_photos.zip"
  handler       = "getPhotos.handler"
  runtime       = "nodejs18.x"
  role          = aws_iam_role.lambda_exec_role.arn
  source_code_hash = filebase64sha256("lambda_get_photos.zip")

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.cat_metadata.name
    }
  }
}

resource "aws_apigatewayv2_api" "http_api" {
  name          = "hdb-cats-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "upload_photo_integration" {
  api_id             = aws_apigatewayv2_api.http_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.upload_photo.invoke_arn
  integration_method = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "get_photos_integration" {
  api_id             = aws_apigatewayv2_api.http_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.get_photos.invoke_arn
  integration_method = "GET"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "upload_photo_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "POST /upload"
  target    = "integrations/${aws_apigatewayv2_integration.upload_photo_integration.id}"
}

resource "aws_apigatewayv2_route" "get_photos_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /photos/{hdb_block}"
  target    = "integrations/${aws_apigatewayv2_integration.get_photos_integration.id}"
}

resource "aws_lambda_permission" "api_gateway_upload" {
  statement_id  = "AllowAPIGatewayInvokeUpload"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.upload_photo.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "api_gateway_get" {
  statement_id  = "AllowAPIGatewayInvokeGet"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_photos.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}
