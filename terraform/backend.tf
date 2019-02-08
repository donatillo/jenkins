terraform {
  backend "s3" {
    bucket = "give-and-take-terraform-master"
    key    = "jenkins.state"
    region = "us-east-1"
  }
}
