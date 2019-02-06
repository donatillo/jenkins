output "nameserver0" {
    value = "${aws_route53_zone.primary.name_servers.0}"
}

output "nameserver1" {
    value = "${aws_route53_zone.primary.name_servers.1}"
}

output "nameserver2" {
    value = "${aws_route53_zone.primary.name_servers.2}"
}

output "nameserver3" {
    value = "${aws_route53_zone.primary.name_servers.3}"
}

# vim:ts=4:sw=4:sts=4:expandtab:syntax=conf
