# TODO - remove this
resource "aws_security_group" "allow_ssh" {
    name            = "allow_ssh"
    description     = "Allow SSH inbound"
    
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "allow_8080" {
    name            = "allow_8080"
    description     = "Allow 8080 inbound"
    
    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "allow_outbound" {
    name            = "allow_all_outbound"
    description     = "Allow all traffic outbound"
    
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# vim:ts=4:sw=4:sts=4:expandtab:syntax=conf
