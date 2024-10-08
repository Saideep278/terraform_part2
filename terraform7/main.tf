resource "aws_instance" "example" {
  ami                    = "ami-0e86e20dae9224db8"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.example_sg.id]

  user_data = <<EOF
#!/bin/bash
echo "Helloworld" > index.html
nohup busybox httpd -f -p 8080 &
EOF
}

resource "aws_security_group" "example_sg" {
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }
}

output "public_ip" {
  value = aws_instance.example.public_ip
}

