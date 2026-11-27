# 1. Создание сети VPC
resource "yandex_vpc_network" "diplom_network" {
  name        = var.network_name
  description = "Сеть для дипломного проекта"
}

# 2. Создание подсетей в 3 зонах доступности
resource "yandex_vpc_subnet" "diplom_subnets" {
  for_each       = var.subnets
  name           = "${var.network_name}-${each.key}"
  zone           = each.value.zone
  network_id     = yandex_vpc_network.diplom_network.id
  v4_cidr_blocks = [each.value.cidr]
}
