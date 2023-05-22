resource "aws_security_group" "example" {
  name        = "allow-port-8080"
  description = "Allow inbound traffic on port 8080"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict the CIDR range as per your requirements
  }
}
