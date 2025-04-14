terraform {
  backend "s3" {
    bucket       = "universe-dev"
    region       = "eu-west-1"
    key          = "sourcefield.tfstate"
    use_lockfile = true
  }
}
