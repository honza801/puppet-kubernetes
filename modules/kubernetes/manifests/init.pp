class kubernetes {
    include apt
    include docker::containerd
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
        source => 'puppet:///modules/kubernetes/sysctl.k8s.conf',
        notify => Exec["sysctl update"],
    }

    $kube_keyring = "/etc/apt/keyrings/kubernetes-archive-keyring.gpg"
    file { "$kube_keyring.armor":
        source => "https://packages.cloud.google.com/apt/doc/apt-key.gpg",
    }~>
    exec { "/usr/bin/gpg --dearmor --batch --yes -o $kube_keyring $kube_keyring.armor":
        refreshonly => true,
        notify => Exec['apt update'],
    }


    file { "/etc/apt/sources.list.d/kubernetes.list":
        content => "deb [signed-by=${kube_keyring}] https://apt.kubernetes.io/ kubernetes-xenial main",
        notify => Exec['apt update'],
    }

    package { $kube_packages:
        ensure => '1.27.1-00',
        mark => hold,
    }

}
