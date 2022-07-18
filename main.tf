terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias = "us-east-2"
  region = "us-east-2"
}

resource "aws_instance" "dev" {
    count = 3
    ami = "ami-052efd3df9dad4825"
    instance_type = "t2.micro"
    key_name = var.key_name
    tags = {
      name = "dev${count.index}"
    }
    vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"]
}


resource "aws_s3_bucket" "dev4" {
  bucket = "fsconsulting-dev4"

  tags = {
    Name = "fsconsulting-dev4"
  }
}

resource "aws_s3_bucket_acl" "fsconsulting-dev4" {
  bucket = "fsconsulting-dev4"
  acl    = "private"
}



resource "aws_instance" "dev4" {
    ami = "ami-052efd3df9dad4825"
    instance_type = "t2.micro"
    key_name = var.key_name
    tags = {
      name = "dev4"
    }
    vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"]
    depends_on = [
      aws_s3_bucket.dev4
    ]
      
    
}

resource "aws_instance" "dev5" {
    ami = var.amis["us-east-1"]
    instance_type = "t2.micro"
    key_name = var.key_name
    tags = {
      name = "dev5"
    }
    vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"]
}

resource "aws_instance" "dev6" {
    provider = aws.us-east-2
    ami = var.amis["us-east-2"]
    instance_type = "t2.micro"
    key_name = var.key_name
    tags = {
      name = "dev6"
    }
    vpc_security_group_ids = ["${aws_security_group.allow_ssh_us-east-2.id}"]
    depends_on = [
      aws_dynamodb_table.dynamodb-table-homolog
    ]
}

resource "aws_instance" "dev7" {
    provider = aws.us-east-2
    ami = var.amis["us-east-2"]
    instance_type = "t2.micro"
    key_name = var.key_name
    tags = {
      name = "dev7"
    }
    vpc_security_group_ids = ["${aws_security_group.allow_ssh_us-east-2.id}"]  
}

resource "aws_dynamodb_table" "dynamodb-table-homolog" {
  provider = aws.us-east-2
  name           = "GameScores"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "UserId"
  range_key      = "GameTitle"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "GameTitle"
    type = "S"
  }

}