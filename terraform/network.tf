# VPC

resource "aws_vpc" "jenkins" {
    cidr_block  = "10.0.0.0/16"
    
    tags {
        Name        = "jenkins-vpc"
        Creator     = "jenkins"
        Description = "Main VPC"
    }
}

# subnet (public)

resource "aws_subnet" "public" {
    vpc_id      = "${aws_vpc.jenkins.id}"
    cidr_block  = "10.0.1.0/24"

    tags {
        Name        = "jenkins-subnet-public"
        Creator     = "jenkins"
        Description = "Main public subnet"
    }
}

# internet gateway

resource "aws_internet_gateway" "ig_public_subnet" {
    vpc_id      = "${aws_vpc.jenkins.id}"

    tags {
        Name        = "jenkins-ig"
        Creator     = "jenkins"
        Description = "Internet gateway for public subnet"
    }
}

# route table (associated to the internet gateway and public subnet)

resource "aws_route_table" "rt" {
    vpc_id      = "${aws_vpc.jenkins.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.ig_public_subnet.id}"
    }

    tags {
        Name        = "jenkins-rt"
        Creator     = "jenkins"
        Description = "Route table for internet gateway"
    }
}

resource "aws_route_table_association" "x" {
    subnet_id       = "${aws_subnet.public.id}"
    route_table_id  = "${aws_route_table.rt.id}"
}

# vim:ts=4:sw=4:sts=4:expandtab:syntax=conf
