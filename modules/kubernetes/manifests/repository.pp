class kubernetes::repository($minor_version) {
    include apt
    
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

}
