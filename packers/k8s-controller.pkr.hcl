packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "debian" {
  image  = "debian:bullseye"
  commit = true
}

build {
  name    = "k8s-node"
  sources = [
    "source.docker.debian"
  ]
}

 "builders": [
    {
      "boot_command": [
        "<esc><wait>",
        "<esc><wait>",
        "<enter><wait>",
        "/install/vmlinuz<wait>",
        " initrd=/install/initrd.gz",
        " auto-install/enable=true",
        " debconf/priority=critical",
        " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed_2.cfg<wait>",
        " -- <wait>",
        "<enter><wait>"
      ],
      "boot_wait": "10s",
      "guest_os_type": "ubuntu-64",
      "http_directory": "http",
      "iso_checksum": "file:///Users/mmarsh/dev/repro_cases/packer_cache/shasums.txt",
      "iso_url": "http://old-releases.ubuntu.com/releases/14.04.1/ubuntu-14.04.1-server-amd64.iso",
      "shutdown_command": "echo 'vagrant' | sudo -S shutdown -P now",
      "ssh_password": "vagrant",
      "ssh_username": "vagrant",
      "ssh_wait_timeout": "10000s",
      "tools_upload_flavor": "linux",
      "type": "vmware-iso"
    }
  ]
