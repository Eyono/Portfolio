resource "aws_s3_bucket" "Terraform-State" {
  bucket = "alarayei-terraform-state"
  force_destroy = true
versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule{
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }
  
  tags = {
    Name        = "Terraform-State-Bucket"
    Environment = "Dev"
  }
}

#create a DynamoDB table for state locking
resource "aws_dynamodb_table" "Terraform-Lock" {
  name = "terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key =  "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

tags = {
    Name        = "Terraform-Lock-Table"
    Environment = "Dev"
  }
}