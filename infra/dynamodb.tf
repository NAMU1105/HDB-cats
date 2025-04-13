resource "aws_dynamodb_table" "cat_metadata" {
  name         = "HDBCatPhotos"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "photo_id"

  attribute {
    name = "photo_id"
    type = "S"
  }

  attribute {
    name = "hdb_block"
    type = "S"
  }

  tags = {
    Project = "HDBCats"
  }
}
