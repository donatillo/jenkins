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
# EC2 jenkins instance
#

resource "aws_instance" "jenkins" {
    ami             = "${data.aws_ami.amazon_linux.id}"
    instance_type   = "t2.micro"
    key_name        = "${aws_key_pair.jenkins_key.key_name}"

    tags {
        Name        = "jenkins"
    }

    security_groups = [
        "${aws_security_group.allow_ssh.name}",
        "${aws_security_group.allow_8080.name}",
        "${aws_security_group.allow_outbound.name}",
    ]

    provisioner "file" {
        source      = "setup_jenkins_aws.sh"
        destination = "/tmp/setup_jenkins_aws.sh"
    }

    provisioner "file" {
        source      = "job.xml"
        destination = "/tmp/job.xml"
    }

    provisioner "file" {
        source      = "config.xml"
        destination = "/tmp/config.xml"
    }

    provisioner "remote-exec" {
        inline 		= [
            "sudo chmod +x /tmp/setup_jenkins_aws.sh",
            "sudo cp /tmp/job.xml /tmp/frontend.xml",
            "sudo cp /tmp/job.xml /tmp/backend.xml",
            "sudo sed -i 's,GIT_REPO,${var.git_repo_frontend},g' /tmp/frontend.xml",
            "sudo sed -i 's,GIT_REPO,${var.git_repo_backend},g' /tmp/backend.xml",
            "sudo sed -i 's,JENKINS_PASSWORD,${var.jenkins_password},g' /tmp/setup_jenkins_aws.sh",
            "sudo sed -i 's,MY_KEY_ID,${var.access_key},g' /tmp/setup_jenkins_aws.sh",
            "sudo sed -i 's,MY_SECRET_KEY,${var.secret_key},g' /tmp/setup_jenkins_aws.sh",
            "sudo /tmp/setup_jenkins_aws.sh",
        ]
    }

    connection {
        type    	= "ssh"
        user    	= "ec2-user"
        timeout 	= "30s"
        private_key = "${file("jenkins_aws.pem")}"
    }
}

# 
# setup static IP
#

resource "aws_eip" "jenkins_eip" {
    instance 		= "${aws_instance.jenkins.id}"

    provisioner "local-exec" {
        command    	= "echo ${self.public_ip} > public_ip.txt"
        on_failure 	= "continue"
    }
}

# vim:ts=4:sw=4:sts=4:expandtab:syntax=conf
