variable "access_key" {}
variable "secret_key" {}

variable "region" {
    default = "us-east-1"
}

variable "jenkins_password"  {}
variable "basename"          {}
variable "domain"            {}
variable "git_repo_init"     {}
variable "git_repo_ssl"      {}
variable "git_repo_frontend" {}
variable "git_repo_backend"  {}

# vim:ts=4:sw=4:sts=4:expandtab:syntax=conf
