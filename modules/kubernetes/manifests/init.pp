class kubernetes {
    include docker
    include sysctl

    $prereqs = [
        "apt-transport-https",
        #"ca-certificates",
        #"curl",
    ]

    $kube_packages = [
        "kubelet",
        "kubeadm",
        "kubectl",
    ]

    package { $prereqs: }

    file { "/etc/modules-load.d/k8s.conf":
        content => "br_netfilter",
    }
    file { "/etc/sysctl.d/k8s.conf":
        content => [
            "net.bridge.bridge-nf-call-ip6tables = 1",
            "net.bridge.bridge-nf-call-iptables = 1",
        ],
        notify => Exec["sysctl update"],
    }

    $kube_keyring = "/usr/share/keyrings/kubernetes-archive-keyring.gpg"
    file { $kube_keyring:
        source => "https://packages.cloud.google.com/apt/doc/apt-key.gpg",
    }

    file { "/etc/apt/sources.list.d/kubernetes.list":
        content => "deb [signed-by=${kube_keyring}] https://apt.kubernetes.io/ kubernetes-xenial main",
        notify => Exec['apt update'],
    }

    package { $kube_packages: }

}
