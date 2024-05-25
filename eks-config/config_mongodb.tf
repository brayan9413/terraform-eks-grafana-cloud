#--------------------------------------------------------------------
# - Mongo DB helm release
# MongoDB is a NoSQL database that stores data in flexible, JSON-like documents 
# It is known for its scalability, flexibility, and ease of use
# - https://artifacthub.io/packages/helm/bitnami/mongodb
#--------------------------------------------------------------------
resource "kubernetes_namespace" "mongodb" {
  metadata {
    name = "mongodb"
  }
}

resource "helm_release" "mongodb" {
  depends_on = [kubernetes_namespace.mongodb]

  name       = "mongodb"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mongodb"
  namespace  = "mongodb"

  set {
    name  = "architecture"
    value = "standalone" # The standalone architecture installs a deployment (or StatefulSet) with one MongoDB® server (it cannot be scaled):
  }

  set {
    name  = "useStatefulSet" # Set to true to use a StatefulSet instead of a Deployment (only when architecture=standalone)
    value = true
  }

  set {
    name  = "auth.enabled" # Set to true to use a StatefulSet instead of a Deployment (only when architecture=standalone)
    value = false
  }
}
