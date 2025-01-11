terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
    }
  }
}

provider "linode" {}

resource "linode_lke_cluster" "elastisys" {
    label       = "elastisys"
    k8s_version = "1.31"
    region      = "se-sto"

    control_plane {
        acl {
            enabled = true
            addresses {
                ipv4 = ["83.253.224.107/32"]
            }
        }
    }

    pool {
        type  = "g6-standard-4"
        count = 3
    }
}

output "kubeconfig" {
    description = "My kubeconfig"
    value       = linode_lke_cluster.elastisys.kubeconfig
    sensitive = true
}
