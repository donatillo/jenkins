output "jenkins-ip" {
    value = "${aws_eip.jenkins_eip.public_ip}"
}

# vim:ts=4:sw=4:sts=4:expandtab:syntax=conf
