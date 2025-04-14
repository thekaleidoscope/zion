terraform {
  backend "s3" {
    bucket       = "universe-prod"
    region       = "eu-west-1"
    key          = "multi_verse_1.tfstate"
    use_lockfile = true
  }
}
