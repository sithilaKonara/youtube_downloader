#Get account ID
data "aws_caller_identity" "current" {}

# Get region
data "aws_region" "current" {}

module "web_backend"{
  source = "./modules/web_backend"
}

module "api_backend"{
  source = "./modules/api_backend"
  v_backend_account_id = data.aws_caller_identity.current.account_id
  v_backend_region_id = data.aws_region.current.name
}