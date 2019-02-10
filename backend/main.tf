#
# VARIABLES
#

variable "access_key" {}
variable "secret_key" {}
variable "appname" {}
variable "region" {
    default = "us-east-1"
}

# 
# SETUP
#

provider "aws" {
    access_key      = "${var.access_key}"
    secret_key      = "${var.secret_key}"
    region          = "${var.region}"
}


# 
# S3 bucket
# 

data "aws_caller_identity" "current" {}

data "template_file" "policy_devl" {
	template 	= "${file("policy.json")}"
	vars {
		user    = "${data.aws_caller_identity.current.arn}"
        env     = "devl"
        appname = "${var.appname}"
	}
}

resource "aws_s3_bucket" "backend_devl" {
    bucket      = "${var.appname}-terraform-devl"
	acl         = "private"
    policy      = "${data.template_file.policy_devl.rendered}"
	versioning {
		enabled = true
	}
}

data "template_file" "policy_master" {
	template 	= "${file("policy.json")}"
	vars {
		user    = "${data.aws_caller_identity.current.arn}"
        env     = "master"
        appname = "${var.appname}"
	}
}

resource "aws_s3_bucket" "backend_master" {
    bucket      = "${var.appname}-terraform-master"
	acl         = "private"
    policy      = "${data.template_file.policy_master.rendered}"
	versioning {
		enabled = true
	}
}

# vim:ts=4:sw=4:sts=4:expandtab:syntax=conf
