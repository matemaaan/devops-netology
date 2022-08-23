terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = ""
  cloud_id  = ""
  zone      = "ru-central1-a"
}

resource "yandex_compute_instance" "instance-1" {
  count    = local.instance_count[terraform.workspace]
  name     = "vm-${terraform.workspace}-${count.index+1}"
  hostname = "vm-${terraform.workspace}-${count.index+1}.netology.cloud"
  zone     = "ru-central1-a"

  resources {
    cores  = local.instance_cores[terraform.workspace]
    memory = local.instance_memory[terraform.workspace]
  }

  boot_disk {
    initialize_params {
      image_id    = "fd81hgrcv6lsnkremf32"
      name        = "root-vm-${terraform.workspace}-${count.index+1}"
      type        = "network-nvme"
      size        = "50"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "my:${file("C:/Users/user/.ssh/id_rsa.pub")}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "yandex_compute_instance" "instance-2" {
  for_each = local.virtual_machines[terraform.workspace]
  name     = "vm-${terraform.workspace}-${each.key}"
  hostname = "vm-${terraform.workspace}-${each.key}.netology.cloud"
  zone     = "ru-central1-a"

  resources {
    cores  = each.value.cores
    memory = each.value.memory
  }

  boot_disk {
    initialize_params {
      image_id    = "fd81hgrcv6lsnkremf32"
      name        = "root-vm-${terraform.workspace}-${each.key}"
      type        = "network-nvme"
      size        = "50"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "my:${file("C:/Users/user/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

locals {
  instance_cores = {
    stage = 2
    prod  = 4
  }

  instance_count = {
    stage = 1
    prod  = 2
  }

  instance_memory = {
    stage = 2
    prod  = 4
  }

  virtual_machines = {
    stage = {
      "2" = { cores = "2", memory = "2" }
    }
    prod = {
      "3" = { cores = "4", memory = "4" },
      "4" = { cores = "4", memory = "4" }
    }
  }
}
