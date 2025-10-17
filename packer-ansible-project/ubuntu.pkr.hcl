packer {
  required_plugins {
    yandex = {
      version = "~> 1"
      source  = "github.com/hashicorp/yandex"
    }
    ansible = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

source "yandex" "ubuntu-flask" {
  folder_id           = var.yc_folder_id
  source_image_family = "ubuntu-2204-lts"
  ssh_username        = "ubuntu"
  use_ipv4_nat        = true
  use_ipv6            = false
  image_description   = "Ubuntu with Flask, Nginx and PostgreSQL"
  image_family        = "ubuntu-flask-app"
  image_name          = "ubuntu-flask-nginx-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
  subnet_id           = var.yc_subnet_id
  disk_type           = "network-ssd"
  zone                = "ru-central1-a"
  platform_id         = "standard-v2"
  instance_cores      = 2
  instance_mem_gb     = 2
  preemptible         = true
  security_group_ids  = ["enp41q80buonomplakuk"]
  
  ssh_private_key_file = pathexpand("~/.ssh/id_rsa")
  
  ssh_timeout            = "20m"
  ssh_handshake_attempts = 50
  ssh_wait_timeout       = "20m"
  ssh_read_write_timeout = "10m"
  
  metadata = {
    serial-port-enable = "1"
    ssh-keys           = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    user-data          = "#cloud-config\nssh_pwauth: false"
  }
}

variable "yc_folder_id" {
  type        = string
  description = "Yandex Cloud folder ID"
}

variable "yc_subnet_id" {
  type        = string
  description = "Yandex Cloud subnet ID"
}

build {
  sources = ["source.yandex.ubuntu-flask"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y python3 python3-pip",
    ]
  }

  provisioner "ansible" {
    playbook_file = "ansible/playbook.yml"
    user          = "ubuntu"
  }
}
