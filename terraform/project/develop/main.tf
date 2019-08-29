terraform {
  backend "remote" {
    organization = "jake-park"
    workspaces {
      name = "develop"
    }
  }
}

provider "aws" {
  region = var.aws_region
  shared_credentials_file = var.shared_credentials_file
}

provider "aws" {
  alias = "virginia"
  region = var.aws_region_virginia
  shared_credentials_file = var.shared_credentials_file
}

###################################################
# VPC
###################################################
module "vpc" {
  source = "../../aws/vpc/"

  name = "${var.stage}-${var.project_name}-vpc"

  cidr = var.cidr

  azs = var.azs
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  database_subnets = var.database_subnets
  elasticache_subnets = var.elasticache_subnets
  deploy_subnets = var.deploy_subnets
  bastion_subnets = var.bastion_subnets

  create_database_subnet_group = true
  create_elasticache_subnet_group = true

  enable_dns_hostnames = true
  enable_dns_support = true

  enable_nat_gateway = true
  single_nat_gateway = true

  create_security_internet_gateway_route = true
  create_deploy_nat_gateway_route = true

  igw_tags = {
    Name = "${var.stage}-${var.project_name}-internet-gw"
  }

  nat_eip_tags = {
    Name = "${var.stage}-${var.project_name}-nat-eip"
  }

  nat_gateway_tags = {
    Name = "${var.stage}-${var.project_name}-nat-gw"
  }

  enable_vpn_gateway = false

  enable_dhcp_options = true
  dhcp_options_domain_name = "${var.aws_region}.compute.internal"
  dhcp_options_domain_name_servers = [
    "AmazonProvidedDNS"
  ]

  # VPC endpoint for S3
  enable_s3_endpoint = true

  # VPC endpoint for DynamoDB
  enable_dynamodb_endpoint = false

  public_dedicated_network_acl = true
  public_inbound_acl_rules = concat(var.network_acls["default_inbound"], var.network_acls["public_inbound"])
  public_outbound_acl_rules = concat(var.network_acls["default_outbound"], var.network_acls["public_outbound"])

  private_dedicated_network_acl = true
  private_inbound_acl_rules = concat(var.network_acls["default_inbound"], var.network_acls["private_inbound"])
  private_outbound_acl_rules = concat(var.network_acls["private_outbound"], var.network_acls["aws_outbound"])

  database_dedicated_network_acl = true
  database_inbound_acl_rules = concat(var.network_acls["database_inbound"])
  database_outbound_acl_rules = concat(var.network_acls["database_outbound"])

  elasticache_dedicated_network_acl = true
  elasticache_inbound_acl_rules = concat(var.network_acls["database_inbound"])
  elasticache_outbound_acl_rules = concat(var.network_acls["database_outbound"])

  deploy_dedicated_network_acl = true
  deploy_inbound_acl_rules = concat(var.network_acls["default_inbound"], var.network_acls["private_inbound"])
  deploy_outbound_acl_rules = concat(var.network_acls["private_outbound"], var.network_acls["aws_outbound"])

  security_dedicated_network_acl = true
  security_inbound_acl_rules = concat(var.network_acls["default_inbound"], var.network_acls["security_inbound"])
  security_outbound_acl_rules = concat(var.network_acls["security_outbound"])

  tags = {
    Owner = var.owner
    Environment = var.stage
  }

  public_acl_tags = {
    Name = "${var.stage}-${var.project_name}-public-acl"
  }

  private_acl_tags = {
    Name = "${var.stage}-${var.project_name}-private-acl"
  }

  database_acl_tags = {
    Name = "${var.stage}-${var.project_name}-database-acl"
  }

  elasticache_acl_tags = {
    Name = "${var.stage}-${var.project_name}-elasticache-acl"
  }

  deploy_acl_tags = {
    Name = "${var.stage}-${var.project_name}-deploy-acl"
  }

  bastion_acl_tags = {
    Name = "${var.stage}-${var.project_name}-security-acl"
  }
}


###################################################
# RDS
###################################################


