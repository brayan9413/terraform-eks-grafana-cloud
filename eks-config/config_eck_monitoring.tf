#--------------------------------------------------------------------
# - ECK elastic helm release
# ECK Stack is a Helm chart to assist in the deployment of Elastic Stack components, which are managed by the 
# - https://artifacthub.io/packages/helm/elastic/eck-stack
#--------------------------------------------------------------------
# Operator
# resource "helm_release" "eck_stack_operator" {
#   name             = "elastic-operator"
#   repository       = "https://helm.elastic.co"
#   chart            = "elastic/eck-operator"
#   namespace        = "elastic-system"
#   create_namespace = true
# }

# # ECK stack
# resource "helm_release" "eck_stack_operator" {
#   name             = "eck-release"
#   repository       = "https://helm.elastic.co"
#   chart            = "elastic/eck-stack"
#   namespace        = "elastic-stack"
#   create_namespace = true
# }
