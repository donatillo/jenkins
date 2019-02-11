#
# add key
# 
resource "aws_key_pair" "jenkins_key" {
    key_name        = "jenkins_key"
    public_key      = "${file("jenkins_aws.pub")}"   
}

# 
# find AMI image
# 

data "aws_ami" "amazon_linux" {
    most_recent    = true
    
    filter {
        name        = "name"
        values      = ["amzn-ami-hvm-????.??.?.????????-x86_64-gp2"]
    }

    filter {
        name        = "state"
        values      = ["available"]
    }

    owners          = ["amazon"]
}

# 
# network interface
#

resource "aws_network_interface" "jenkins" {
    subnet_id       = "${aws_subnet.public.id}"
    private_ips      = ["10.0.1.50"]
    
    security_groups = [
        "${aws_security_group.allow_ssh.id}",
        "${aws_security_group.allow_8080.id}",
        "${aws_security_group.allow_outbound.id}",
    ]

    tags {
        Name        = "jenkins-network-if"
        Creator     = "jenkins"
        Description = "Jenkins instance network interface"
    }
}

# 
# EC2 jenkins instance
#

resource "aws_instance" "jenkins" {
    ami             = "${data.aws_ami.amazon_linux.id}"
    instance_type   = "t2.micro"
    key_name        = "${aws_key_pair.jenkins_key.key_name}"

    // provisioner "local-exec" {
    //     command    	= "./create_key.sh"
    // }

    network_interface {
        network_interface_id = "${aws_network_interface.jenkins.id}"
        device_index         = 0
    }

    tags {
        Name        = "jenkins"
        Creator     = "jenkins"
        Description = "Main jenkins instance"
    }
}

# 
# setup static IP
#

resource "aws_eip" "jenkins_eip" {
    instance 		= "${aws_instance.jenkins.id}"
    vpc             = true

    provisioner "local-exec" {
        command    	= "echo ${self.public_ip} > public_ip.txt"
        on_failure 	= "continue"
    }

    provisioner "local-exec" {
        command    	= "echo 'Connect to ssh with: ssh -i jenkins_aws.pem ec2-user@`cat public_ip.txt`' && echo 'Jenkins available at http://`cat public_ip.txt`:8080'"
        on_failure 	= "continue"
    }

    tags {
        Name        = "jenkins-eip"
        Creator     = "jenkins"
        Description = "Main Jenkins instance elastic IP"
    }
}

# vim:ts=4:sw=4:sts=4:expandtab:syntax=conf
