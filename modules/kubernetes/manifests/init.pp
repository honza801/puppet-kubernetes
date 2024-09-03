class kubernetes {
    include common
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

    class { 'kubernetes::repository':
        minor_version => $minor_version,
    }

    package { $kube_packages:
        ensure => "${minor_version}.${patch_version}-00",
        mark => hold,
    }

}
