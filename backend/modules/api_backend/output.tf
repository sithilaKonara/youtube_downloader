output "o_api_gateway_url" {
  value = {
    get_endpoint = "${aws_api_gateway_deployment.r_ytd_api_gw_deployment.invoke_url}/ytd/ytd_get"
    download_endpoint = "${aws_api_gateway_deployment.r_ytd_api_gw_deployment.invoke_url}/ytd/ytd_download"
  }  
}