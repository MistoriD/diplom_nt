# Автоматическая генерация ansible/inventory.ini при применении terraform apply
resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../../ansible/inventory.ini"
  content  = <<-EOF
[masters]
master-01 ansible_host=${yandex_compute_instance.k8s_node["master-01"].network_interface[0].nat_ip_address} internal_ip=${yandex_compute_instance.k8s_node["master-01"].network_interface[0].ip_address}

[workers]
worker-01 ansible_host=${yandex_compute_instance.k8s_node["worker-01"].network_interface[0].nat_ip_address} internal_ip=${yandex_compute_instance.k8s_node["worker-01"].network_interface[0].ip_address}
worker-02 ansible_host=${yandex_compute_instance.k8s_node["worker-02"].network_interface[0].nat_ip_address} internal_ip=${yandex_compute_instance.k8s_node["worker-02"].network_interface[0].ip_address}

[k8s_cluster:children]
masters
workers

[k8s_cluster:vars]
ansible_user=ubuntu
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
k8s_version=1.28
pod_network_cidr=10.244.0.0/16
EOF
}
