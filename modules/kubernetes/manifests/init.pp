class kubernetes {
    include common
    include apt
    include docker::containerd
    include sysctl

    $minor_version = "1.29"
    $patch_version = "5"

    $prereqs = [
        "apt-transport-https",
        #"ca-certificates",
        #"curl",
        'gpg',
    ]

    $kube_packages = [
        "kubelet",
        "kubeadm",
        "kubectl",
    ]

    package { $prereqs: }

    file { "/etc/modules-load.d/k8s.conf":
        source => 'puppet:///modules/kubernetes/modules.k8s.conf',
        owner => 'root', group => 'root', mode => '0644',
    }
    file { "/etc/sysctl.d/k8s.conf":
        source => 'puppet:///modules/kubernetes/sysctl.k8s.conf',
        owner => 'root', group => 'root', mode => '0644',
        notify => Exec["sysctl update"],
    }

    $kube_keyring = "/etc/apt/keyrings/kubernetes-apt-keyring.gpg"
    file { "$kube_keyring.armor":
        source => "https://pkgs.k8s.io/core:/stable:/v${minor_version}/deb/Release.key",
    }~>
    exec { "/usr/bin/gpg --dearmor --batch --yes -o $kube_keyring $kube_keyring.armor":
        refreshonly => true,
        notify => Exec['apt update'],
    }


    file { "/etc/apt/sources.list.d/kubernetes.list":
        content => "deb [signed-by=${kube_keyring}] https://pkgs.k8s.io/core:/stable:/v${minor_version}/deb/ /",
        notify => Exec['apt update'],
    }

    package { $kube_packages:
        ensure => "${minor_version}.${patch_version}-00",
        mark => hold,
    }

}
