# Zion: Unified App + Infra GitOps

This repo demonstrates a single Git flow that delivers both application services and cloud infrastructure together. It uses Helm to package services and infra modules, Crossplane to model cloud infra as Kubernetes CRDs, and CI to plan/apply Terraform for cluster scaffolding. ArgoCD (or any GitOps controller) can watch paths in this repo so a single push updates everything consistently.

## Branches
- **main**: Terraform scaffolding for clusters/environments; baseline starting point.
- **helm-module**: Helm-only packaging for a simple microservice.
- **crossplane-modules**: Helm charts that declare cloud infra via Crossplane-managed CRDs (e.g., S3, RDS).
- **crossplane-crd**: Adds custom XRD + Composition examples to define portable infra APIs (e.g., `Bucket` + `Composition`).

Switch with `git checkout <branch>` to explore each stage of the journey.

## Layout
- `helm-charts/`: Reusable Helm charts
  - `micro-service/`: Generic K8s service chart
  - `s3/`, `rds/`: Infra modules that render Crossplane AWS CRDs
- `examples/`: Minimal, runnable examples that consume the charts
  - `micro-service/`, `s3/`, `rds/`
  - `s3-crd/`: Example using Crossplane XRD/Composition and a `BucketClaim`
- `crds/`: Crossplane XRDs and Compositions (e.g., `s3/bucket-*`)
- `cluster/`: Terraform to stand up EKS clusters per env (`dev`, `prod`)
- `universe/`: Terraform for other environment groups (`prime`, `multi-verse-1`, `sourcefield`)
- `.github/`: CI workflows (Terraform plan/apply examples)

## Tools
- `git`: versioning and branch-based flows
- `helm`: package and deploy services + infra modules
- `kubectl`: apply CRDs/claims and inspect resources
- `crossplane` (installed in-cluster): manage cloud infra via CRDs
- `terraform`: provision/maintain cluster or foundational infra
- Optional: `argocd` for GitOps-driven sync

## Prerequisites
- Kubernetes cluster with permissions (`kubectl` points to it)
- Helm v3
- Crossplane installed in the cluster with AWS provider configured
  - ProviderConfig named `aws-provider` (referenced by the charts/CRDs)
- Terraform >= 1.4 and AWS credentials for `terraform` and Crossplane

## Explore Quickly
- List branches: `git branch -a`
- Browse files: `rg --files` or `tree -L 3`
- Search examples: `rg -n "helm|crossplane|Composition|BucketClaim|rds|s3"`

## Helm: Deploy a Microservice
- Update deps: `helm dependency update examples/micro-service`
- Install: `helm upgrade -i service-1 examples/micro-service -n apps --create-namespace`
- Verify: `kubectl get deploy,svc -n apps`

## Helm: Provision Cloud Infra via Crossplane
- Ensure Crossplane + AWS provider are installed and `ProviderConfig` exists.
- S3 example:
  - `helm dependency update examples/s3`
  - `helm upgrade -i s3-example examples/s3 -n infra --create-namespace`
  - Inspect: `kubectl get buckets.s3.aws.upbound.io -n infra`
- RDS example:
  - `helm dependency update examples/rds`
  - `helm upgrade -i rds-example examples/rds -n infra`
  - Inspect: `kubectl get dbinstances.rds.aws.upbound.io -n infra`

## Crossplane XRD + Composition (portable API)
- Apply XRD + Composition: `kubectl apply -f crds/s3/bucket-crd.yaml -f crds/s3/bucket-composition.yaml`
- Claim a bucket: `kubectl apply -f examples/s3-crd/bucket.yaml`
- Observe: `kubectl get bucketclaims.zion.com`, and the composed AWS resources under `s3.aws.upbound.io/*`

## Terraform: Cluster and Environment Scaffolding
- Dev cluster: `cd cluster/dev && terraform init && terraform plan && terraform apply`
- Prod cluster: `cd cluster/prod && terraform init && terraform plan`
- Other envs: `cd universe/<group>/<env> && terraform init && terraform plan`

Note: GitHub Actions under `.github/workflows` show a Terraform plan/apply pattern. Adjust the working directories to match `cluster/` or `universe/` if you wire these up in your org.

## GitOps with ArgoCD (optional)
- Point an ArgoCD `Application` to a path like `examples/s3` or `helm-charts/micro-service` with your target namespace. Commit changes to values or templates and ArgoCD syncs them.
- Typical flow: developer changes app/infra in one PR → merge → ArgoCD syncs Helm charts and Crossplane creates/updates cloud resources.

## Clean Up
- Helm: `helm uninstall <release> -n <ns>`
- Crossplane claim: `kubectl delete -f examples/s3-crd/bucket.yaml`
- Terraform: `terraform destroy` in the respective directory
