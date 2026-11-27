output "network_id" {
  value       = yandex_vpc_network.diplom_network.id
  description = "ID сети"
}

output "subnet_ids" {
  value       = { for k, v in yandex_vpc_subnet.diplom_subnets : k => v.id }
  description = "ID подсетей по зонам"
}

output "k8s_hosts" {
  value = {
    for name, instance in yandex_compute_instance.k8s_node : name => {
      external_ip = instance.network_interface[0].nat_ip_address
      internal_ip = instance.network_interface[0].ip_address
      zone        = instance.zone
    }
  }
  description = "IP адреса созданных нод для Kubernetes"
}
