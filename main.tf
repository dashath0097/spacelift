terraform {
  required_providers {
    spacelift = {
      source  = "spacelift-io/spacelift"
      version = "~> 1.0"
    }
  }
}

provider "spacelift" {
  # Ensure credentials are set via environment variables or Spacelift access keys
}

# Fetch the AWS Account ID from the blueprint input
variable "aws_account_id" {
  description = "AWS Account ID provided in the blueprint"
  type        = string
}

# Create the Spacelift AWS integration
resource "spacelift_aws_integration" "aws_integration" {
  name                            = "aws-integration-${var.aws_account_id}"
  role_arn                        = "arn:aws:iam::${var.aws_account_id}:role/SpaceliftIntegrationRole"
  generate_credentials_in_worker  = false
}

# Optional: Attach the integration to the stack
resource "spacelift_aws_integration_attachment" "integration_attachment" {
  integration_id = spacelift_aws_integration.aws_integration.id
  stack_id       = spacelift_stack.stack.id
  read           = true
  write          = true
}

# Define the Spacelift stack
resource "spacelift_stack" "stack" {
  name  = var.stack_name
  space = "root"

  vcs {
    provider   = "GITHUB_ENTERPRISE"
    namespace  = "dashath0097"
    repository = "spacelift"
    branch     = "main"
  }

  vendor {
    terraform {
      manage_state = true
      version      = "1.3.0"
    }
  }
}
