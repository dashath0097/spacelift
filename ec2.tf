
resource "aws_instance" "example" {
  ami                    = "ami-0c614dee691cbbf37" # Change this to a valid AMI ID for your region
  instance_type          = "t2.micro"
  
  
  tags = {
    Name = "Terraform-EC2"
  }
}
