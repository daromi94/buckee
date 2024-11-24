output "vpc_id" {
  value = module.network.vpc_id
}

output "k8s_cluster_arn" {
  value = module.k8s.cluster_arn
}
