provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.endpoint #your eks
    cluster_ca_certificate = base64decode(aws_eks_cluster.certificate_authority[0].data) #your ssl certificate
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.id] 
      command     = "aws"
    }
  }
}    
resource "helm_release" "ingress_nginx" {
  name = "staging"

  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
  version          = "4.4.0"

  set {
    name  = "controller.ingressClassResource.name"
    value = "external-ingress-nginx"
  }

  set {
    name  = "controller.metrics.enabled"
    value = "true"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "nlb"
  }
}