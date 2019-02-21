variable "access_key"        {}
variable "secret_key"        {}
variable "jenkins_password"  {}
variable "basename"          {}
variable "domain"            {}
variable "git_repo_infra"    {}
variable "git_repo_frontend" {}
variable "git_repo_backend"  {}

provider "aws" {
    access_key      = "${var.access_key}"
    secret_key      = "${var.secret_key}"
    region          = "us-east-1"
}

# vim:ts=4:sw=4:sts=4:expandtab:syntax=conf
