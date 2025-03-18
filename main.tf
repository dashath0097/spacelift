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

# Fetch Stack Name instead of Stack ID
variable "stack_name" {
  description = "Spacelift Stack Name"
  type        = string
}

# Get the current stack details using name instead of ID
data "spacelift_stack" "current" {
  name = var.stack_name
}

# Create an AWS integration in Spacelift
resource "spacelift_aws_integration" "aws_integration" {
  name     = "aws-integration-${var.aws_account_id}"
  role_arn = "arn:aws:iam::${var.aws_account_id}:role/Spacelift"
  generate_credentials_in_worker = false
}

# Attach the integration to the current stack using stack_name
resource "spacelift_aws_integration_attachment" "aws_attach" {
  integration_id = spacelift_aws_integration.aws_integration.id
  stack_id       = data.spacelift_stack.current.id
  read           = true
  write          = true
}
