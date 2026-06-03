data "tls_certificate" "oidc" {
  count = var.create_oidc_provider ? 1 : 0

  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}
