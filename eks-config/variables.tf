variable "aws_region" {
  default     = "us-east-1"
  description = "aws region"
}

variable "env_name" {
  default     = "dev"
  description = "environment"
}

# INPUTS
variable "eks_oidc_provider" { # input
  description = "eks oidc ID provider"
}

variable "eks_cluster_endpoint" { # input
  description = "eks cluster endpoint"
}

variable "eks_cluster_certificate_authority_data" { # input
  description = "eks certificate authority data"
}

variable "eks_cluster_name" { # input
  description = "eks cluster name"
}

# GRAFANA CLOUD
variable "externalservices_prometheus_host" {
  type    = string
  default = "https://prometheus-prod-13-prod-us-east-0.grafana.net"
}

variable "externalservices_prometheus_basicauth_username" {
  type    = number
  default = 1586015
}

variable "externalservices_prometheus_basicauth_password" {
  description = "external INPUT env var"
  type        = string
}

variable "externalservices_loki_host" {
  type    = string
  default = "https://logs-prod-006.grafana.net"
}

variable "externalservices_loki_basicauth_username" {
  type    = number
  default = 892945
}

variable "externalservices_loki_basicauth_password" {
  type        = string
  description = "external INPUT env var"
}

variable "externalservices_tempo_host" {
  type    = string
  default = "https://tempo-prod-04-prod-us-east-0.grafana.net:443"
}

variable "externalservices_tempo_basicauth_username" {
  type    = number
  default = 887261
}

variable "externalservices_tempo_basicauth_password" {
  type        = string
  description = "external INPUT env var"
}

variable "metrics_enabled" {
  type    = bool
  default = true
}

variable "metrics_cost_enabled" {
  type    = bool
  default = true
}

variable "metrics_node_exporter_enabled" {
  type    = bool
  default = true
}

variable "logs_enabled" {
  type    = bool
  default = true
}

variable "logs_pod_logs_enabled" {
  type    = bool
  default = true
}

variable "logs_cluster_events_enabled" {
  type    = bool
  default = true
}

variable "traces_enabled" {
  type    = bool
  default = true
}

variable "receivers_grpc_enabled" {
  type    = bool
  default = true
}

variable "receivers_http_enabled" {
  type    = bool
  default = true
}

variable "receivers_zipkin_enabled" {
  type    = bool
  default = true
}

variable "opencost_enabled" {
  type    = bool
  default = true
}

variable "opencost_opencost_exporter_defaultclusterid" {
  type    = string
  default = "br-eks-sample"
}

variable "opencost_opencost_prometheus_external_url" {
  type    = string
  default = "https://prometheus-prod-13-prod-us-east-0.grafana.net/api/prom"
}

variable "kube_state_metrics_enabled" {
  type    = bool
  default = true
}

variable "prometheus_node_exporter_enabled" {
  type    = bool
  default = true
}

variable "prometheus_operator_crds_enabled" {
  type    = bool
  default = true
}
