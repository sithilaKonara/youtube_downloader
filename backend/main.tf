#Get account ID
data "aws_caller_identity" "current" {}

# Get region
data "aws_region" "current" {}

module "web_backend"{
  source = "./modules/web_backend"
  v_web_backend_app_name = var.app_name
}

module "api_backend"{
  source = "./modules/api_backend"
  v_api_backend_app_name = var.app_name
  v_backend_account_id = data.aws_caller_identity.current.account_id
  v_backend_region_id = data.aws_region.current.name
  v_backend_cloudfront_distribution_url = module.web_backend.o_cloudfront_distribution_url
  v_backend_s3_bkt_name = module.web_backend.o_s3_bkt_name
}

output "o_api_endpoints" {
  value = module.api_backend.o_api_gateway_url
}