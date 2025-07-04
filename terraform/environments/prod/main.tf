module "postgresql" {
  source              = "../../services/postgresql"
  postgresql_password = var.postgresql_password
}

module "redis" {
  source         = "../../services/redis"
  redis_password = var.redis_password
}

module "ingress_nginx" {
  source          = "../../services/ingress-nginx"
  name            = "ingress-nginx"
  namespace       = "ingress-nginx"
  chart_version   = "4.10.0"
  node_port_http  = 30288
  node_port_https = 30333
}

module "rabbitmq" {
  source            = "../../services/rabbitmq"
  name              = "rabbitmq"
  namespace         = "rabbitmq"
  chart_version     = "12.0.5"
  rabbitmq_password = var.rabbitmq_password
  base_domain       = var.base_domain
}

module "plane" {
  source              = "../../services/plane"
  redis_password      = var.redis_password
  postgresql_password = var.postgresql_password
  secret_key          = var.secret_key
  base_domain         = var.base_domain
  rabbitmq_password   = var.rabbitmq_password
}

module "gitea" {
  source               = "../../services/gitea"
  name                 = "gitea"
  namespace            = "gitea"
  chart_version        = "10.1.2"
  postgresql_password  = var.postgresql_password
  redis_password       = var.redis_password
}

module "harbor" {
  source              = "../../services/harbor"
  postgresql_password = var.postgresql_password
  redis_password      = var.redis_password
  harbor_admin_password = var.harbor_admin_password
}

module "woodpecker" {
  source = "../../services/woodpecker"

  woodpecker_agent_secret = var.woodpecker_agent_secret
  woodpecker_admin        = var.woodpecker_admin
  gitea_server            = var.gitea_server
  gitea_client_id         = var.gitea_client_id
  gitea_client_secret     = var.gitea_client_secret
}

module "argocd" {
  source = "../../services/argocd"
  hostname = "argocd.mafialegends.site"
}

module "portainer" {
  source    = "../../services/portainer"
  hostname  = "portainer.mafialegends.site"
}

module "local_path_provisioner" {
  source        = "../../modules/local_path_provisioner"
  name          = "local-path-provisioner"
  namespace     = "local-path-provisioner"
  storage_path  = "/home/kubernetes/volumes"
}
