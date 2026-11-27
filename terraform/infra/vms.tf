# Образ Ubuntu 22.04 LTS
data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

# Описание виртуальных машин
# master-01: 2 vCPU, 4 GB RAM, 20% core_fraction (минимальная стоимость для мастера K8s)
# worker-01, worker-02: 2 vCPU, 2 GB RAM, 20% core_fraction (прерываемые)
locals {
  k8s_nodes = {
    "master-01" = {
      subnet_name   = "subnet-a"
      cores         = 2
      memory        = 4
      core_fraction = 20
      disk_size     = 30
      is_master     = true
    }
    "worker-01" = {
      subnet_name   = "subnet-a"
      cores         = 2
      memory        = 2
      core_fraction = 20
      disk_size     = 30
      is_master     = false
    }
    "worker-02" = {
      subnet_name   = "subnet-d"
      cores         = 2
      memory        = 2
      core_fraction = 20
      disk_size     = 30
      is_master     = false
    }
  }
}

resource "yandex_compute_instance" "k8s_node" {
  for_each = local.k8s_nodes

  name        = each.key
  hostname    = each.key
  platform_id = "standard-v3"
  zone        = var.subnets[each.value.subnet_name].zone

  resources {
    cores         = each.value.cores
    memory        = each.value.memory
    core_fraction = each.value.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      type     = "network-hdd"
      size     = each.value.disk_size
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.diplom_subnets[each.value.subnet_name].id
    nat       = true # Внешний IP для SSH и доступа в Интернет
  }

  scheduling_policy {
    preemptible = true # Прерываемые ВМ (максимальная экономия бюджета!)
  }

  metadata = {
    ssh-keys  = "ubuntu:${var.ssh_public_key}"
    user-data = <<-EOF
      #cloud-config
      datasource_list: [ None ]
      users:
        - name: ubuntu
          sudo: ALL=(ALL) NOPASSWD:ALL
          shell: /bin/bash
          ssh_authorized_keys:
            - ${var.ssh_public_key}
    EOF
  }

  labels = {
    role = each.value.is_master ? "master" : "worker"
    node = each.key
  }
}
