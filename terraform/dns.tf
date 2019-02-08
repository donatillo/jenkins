resource "aws_route53_zone" "primary" {
    name 			= "${var.domain}"
    lifecycle {
        prevent_destroy = true
    }
}

# vim:ts=4:sw=4:sts=4:expandtab:syntax=conf
