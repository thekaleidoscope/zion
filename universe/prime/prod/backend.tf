terraform {
  backend "s3" {
    bucket       = "universe-prod"
    region       = "eu-west-1"
    key          = "prime.tfstate"
    use_lockfile = true
  }
}
