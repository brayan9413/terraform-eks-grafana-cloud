#--------------------------------------------------------------------------------
# Namespaces
# In Kubernetes, namespaces provides a mechanism for isolating groups of resources within a single cluster
#--------------------------------------------------------------------------------
resource "kubernetes_namespace" "service" {
  for_each = toset(local.service_list)
  metadata {
    name = "${each.key}-${var.env_name}"
  }
}
