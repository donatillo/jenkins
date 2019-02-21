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

    tags {
        Name        = "jenkins-allow_ssh"
        Creator     = "jenkins"
        Description = "Allow SSH inbound"
    }
}

resource "aws_security_group" "allow_443" {
    name            = "allow_443"
    description     = "Allow 443 inbound"

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
        Name        = "jenkins-allow_443"
        Creator     = "jenkins"
        Description = "Allow port 443 inbound"
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

    tags {
        Name        = "jenkins-allow_8080"
        Creator     = "jenkins"
        Description = "Allow port 8080 inbound"
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

    tags {
        Name        = "jenkins-allow_outbound"
        Creator     = "jenkins"
        Description = "Allow all traffic outbound"
    }
}

# vim:ts=4:sw=4:sts=4:expandtab:syntax=conf
