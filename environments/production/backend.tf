# terraform {
#   backend "s3" {
#     bucket = "bucket-name"
#     key = "three-tier/stage.tfstate"
#     region = "ap-southeast-1"
#     encrypt = true
#     dynamodb_table = "value"
#   }
# }