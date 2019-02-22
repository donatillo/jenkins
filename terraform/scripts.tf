resource "null_resource" "scripts" {
    triggers = {
        instance = "${aws_instance.jenkins.id}"
    }

    depends_on = ["aws_instance.jenkins", "aws_eip.jenkins_eip"]

    connection {
        type    	= "ssh"
        host        = "${aws_eip.jenkins_eip.public_ip}"
        user    	= "ec2-user"
        timeout 	= "30s"
        private_key = "${file("jenkins_aws.pem")}"
    }

    provisioner "file" {
        source      = "files/setup_jenkins_aws.sh"
        destination = "/tmp/setup_jenkins_aws.sh"
    }

    provisioner "file" {
        source      = "files/job.xml"
        destination = "/tmp/job.xml"
    }

    provisioner "file" {
        source      = "files/config.xml"
        destination = "/tmp/config.xml"
    }

    provisioner "file" {
        source      = "files/awscred.xml"
        destination = "/tmp/awscred.xml"
    }

    provisioner "remote-exec" {
        inline 		= [
            "sudo chmod +x /tmp/setup_jenkins_aws.sh",
            "sudo cp /tmp/job.xml /tmp/infra.xml",
            "sudo cp /tmp/job.xml /tmp/frontend.xml",
            "sudo cp /tmp/job.xml /tmp/backend.xml",
            "sudo sed -i 's,GIT_REPO,${var.git_repo_infra},g' /tmp/infra.xml",
            "sudo sed -i 's,GIT_REPO,${var.git_repo_frontend},g' /tmp/frontend.xml",
            "sudo sed -i 's,GIT_REPO,${var.git_repo_backend},g' /tmp/backend.xml",
            "sudo sed -i 's,JENKINS_PASSWORD,${var.jenkins_password},g' /tmp/setup_jenkins_aws.sh",
            "sudo sed -i 's,MY_APP_NAME,${var.basename},g' /tmp/setup_jenkins_aws.sh",
            "sudo sed -i 's,MY_APP_NAME,${var.basename},g' /tmp/job.xml",
            "sudo sed -i 's,MY_AWS_DOMAIN,${var.domain},g' /tmp/setup_jenkins_aws.sh",
            "sudo sed -i 's,MY_MAIN_AWS_DOMAIN,${var.main_domain},g' /tmp/setup_jenkins_aws.sh",
            "sudo sed -i 's,MY_BASENAME,${var.basename},g' /tmp/setup_jenkins_aws.sh",
            "sudo sed -i 's,MY_KEY_ID,${var.access_key},g' /tmp/awscred.xml",
            "sudo sed -i 's,MY_SECRET_KEY,${var.secret_key},g' /tmp/awscred.xml",
            "sudo /tmp/setup_jenkins_aws.sh",
        ]
    }
}

# vim:ts=4:sw=4:sts=4:expandtab:syntax=conf
