terraform {
  required_providers {
    spacelift = {
      source  = "spacelift-io/spacelift"
      version = "~> 1.0"
    }
  }
}

provider "spacelift" {
  # Spacelift API credentials (configured via environment variables)
}

# Fetch AWS Account ID from input
variable "aws_account_id" {
  description = "AWS Account ID for integration"
  type        = string
}

# Fetch Stack Name (used as stack_id)
variable "stack_name" {
  description = "Spacelift Stack Name"
  type        = string
}

# Create an AWS integration in Spacelift
resource "spacelift_aws_integration" "aws_integration" {
  name     = "aws-integration-${var.aws_account_id}"
  role_arn = "arn:aws:iam::${var.aws_account_id}:role/Spacelift"
  generate_credentials_in_worker = false
}
# Attach the AWS integration to the specified Spacelift stack
resource "spacelift_aws_integration_attachment" "aws_attach" {
  stack_id       = var.stack_name
  integration_id = spacelift_aws_integration.aws_integration.id
  read           = true  # Allow read access
  write          = true  # Allow write access
}
