
resource "random_pet" "s3_bucket_name" {
  prefix = "website"
  length = 4
}

resource "aws_s3_bucket" "dynamic_bucket" {
  bucket = random_pet.s3_bucket_name.id
  tags = {
    "Department" = "Marketing"
  }
  
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.dynamic_bucket.id
  acl    = "public-read"
}
resource "aws_s3_bucket_public_access_block" "bucket_pub_access" {
  bucket = aws_s3_bucket.dynamic_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  #ignore_public_acls      = true
  #restrict_public_buckets = true
}
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.dynamic_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_website_configuration" "bucket_website" {
  bucket = aws_s3_bucket.dynamic_bucket.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
  
}

resource "aws_s3_object" "bucket_upload" {
  
  for_each = fileset("./upload/", "**")
  key = each.value
  bucket = aws_s3_bucket.dynamic_bucket.id
  source = "./upload/${each.value}"
  etag = filemd5("./upload/${each.value}")
  acl = "public-read"
  
}


resource "null_resource" "url" {
  triggers = {
    build_number = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "printf '%s' $(aws s3 presign s3://${aws_s3_bucket.dynamic_bucket.id}/index.html) > url"
  }
}

data "local_file" "url" {
  depends_on = [
    null_resource.url
  ]
  filename = "${path.module}/url"
}

output  "url" {
  value = data.local_file.url.content
}



