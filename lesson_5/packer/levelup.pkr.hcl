variable "vm_name" {
  default = "webbooks"
}

variable "jdk_version" {
  default = "17"
}

variable "maven_version" {
  default = "3.6.3"
}

variable "postgresql_version" {
  default = "12"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

packer {
  required_plugins {
    vagrant = {
      version = "~> 1"
      source  = "github.com/hashicorp/vagrant"
    }
  }
}

source "vagrant" "autogenerated" {
  add_force    = true
  communicator = "ssh"
  provider     = "virtualbox"
  source_path  = "bento/ubuntu-20.04"
}


build {
  sources = ["source.vagrant.autogenerated"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y openjdk-${var.jdk_version}-jdk",
      "sudo apt-get -y install maven",
      "sudo apt-get install -y postgresql",
      "sudo systemctl enable postgresql",
      "sudo systemctl start postgresql"
    ]
  }
}