terraform {
  backend "s3" {
    bucket       = "universe-prod"
    region       = "eu-west-1"
    key          = "cluster.tfstate"
    use_lockfile = true
  }
}
