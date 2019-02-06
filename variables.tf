variable "access_key" {}

variable "secret_key" {}

variable "jenkins_password" {}

variable "region" {
    default = "us-east-1"
}

variable "domain" {
    default = "give-and-take.tk"
}

variable "git_repo_frontend" {
    default = "https://github.com/give-and-take/frontend.git"
}

variable "git_repo_backend" {
    default = "https://github.com/give-and-take/backend.git"
}

# vim:ts=4:sw=4:sts=4:expandtab:syntax=conf
