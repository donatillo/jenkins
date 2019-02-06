data "aws_route53_zone" "primary" {
    name 			= "${var.domain}"
}

resource "aws_route53_record" "jenkins-dns" {
	zone_id 		= "${data.aws_route53_zone.primary.zone_id}"
	name			= "jenkins.${var.domain}"
	type			= "A"
	ttl				= "300"
	records			= ["${aws_eip.jenkins_eip.public_ip}"]
}

# vim:ts=4:sw=4:sts=4:expandtab:syntax=conf
