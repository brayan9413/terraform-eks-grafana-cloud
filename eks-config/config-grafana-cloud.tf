#--------------------------------------------------------------------
# - Grafana helm release
# A Helm chart for gathering, scraping, and forwarding Kubernetes telemetry data to a Grafana Stack.
# - https://staging.artifacthub.io/packages/helm/grafana/k8s-monitoring
#--------------------------------------------------------------------
resource "helm_release" "grafana-k8s-monitoring" {
  name             = "grafana-k8s-monitoring"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "k8s-monitoring"
  namespace        = "monitoring"
  create_namespace = true
  atomic           = true
  timeout          = 300

  # Custom configuration
  #  List of values in raw yaml to pass to helm. Values will be merged, in order, as Helm does with multiple -f options
  values = [file("${path.module}/templates/grafana-alloy-config.yaml")]

  set {
    name  = "cluster.name"
    value = var.eks_cluster_name
  }

  set {
    name  = "externalServices.prometheus.host"
    value = var.externalservices_prometheus_host
  }

  set_sensitive {
    name  = "externalServices.prometheus.basicAuth.username"
    value = var.externalservices_prometheus_basicauth_username
  }

  set_sensitive {
    name  = "externalServices.prometheus.basicAuth.password"
    value = var.externalservices_prometheus_basicauth_password
  }

  set {
    name  = "externalServices.loki.host"
    value = var.externalservices_loki_host
  }

  set_sensitive {
    name  = "externalServices.loki.basicAuth.username"
    value = var.externalservices_loki_basicauth_username
  }

  set_sensitive {
    name  = "externalServices.loki.basicAuth.password"
    value = var.externalservices_loki_basicauth_password
  }

  set {
    name  = "externalServices.tempo.host"
    value = var.externalservices_tempo_host
  }

  set_sensitive {
    name  = "externalServices.tempo.basicAuth.username"
    value = var.externalservices_tempo_basicauth_username
  }

  set_sensitive {
    name  = "externalServices.tempo.basicAuth.password"
    value = var.externalservices_tempo_basicauth_password
  }

  set {
    name  = "metrics.enabled"
    value = var.metrics_enabled
  }

  set {
    name  = "metrics.cost.enabled"
    value = var.metrics_cost_enabled
  }

  set {
    name  = "metrics.node-exporter.enabled"
    value = var.metrics_node_exporter_enabled
  }

  set {
    name  = "logs.enabled"
    value = var.logs_enabled
  }

  set {
    name  = "logs.pod_logs.enabled"
    value = var.logs_pod_logs_enabled
  }

  set {
    name  = "logs.cluster_events.enabled"
    value = var.logs_cluster_events_enabled
  }

  set {
    name  = "traces.enabled"
    value = var.traces_enabled
  }

  set {
    name  = "receivers.grpc.enabled"
    value = var.receivers_grpc_enabled
  }

  set {
    name  = "receivers.http.enabled"
    value = var.receivers_http_enabled
  }

  set {
    name  = "receivers.zipkin.enabled"
    value = var.receivers_zipkin_enabled
  }

  set {
    name  = "opencost.enabled"
    value = var.opencost_enabled
  }

  set {
    name  = "opencost.opencost.exporter.defaultClusterId"
    value = var.opencost_opencost_exporter_defaultclusterid
  }

  set {
    name  = "opencost.opencost.prometheus.external.url"
    value = var.opencost_opencost_prometheus_external_url
  }

  set {
    name  = "kube-state-metrics.enabled"
    value = var.kube_state_metrics_enabled
  }

  set {
    name  = "prometheus-node-exporter.enabled"
    value = var.prometheus_node_exporter_enabled
  }

  set {
    name  = "prometheus-operator-crds.enabled"
    value = var.prometheus_operator_crds_enabled
  }
}
