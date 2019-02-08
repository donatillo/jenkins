terraform {
  backend "s3" {
    bucket = "give-and-take-terraform"
    key    = "jenkins.state"
    region = "us-east-1"
  }
}
