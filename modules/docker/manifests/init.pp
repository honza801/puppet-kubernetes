class docker {
    include apt

    $prereq = [
        "ca-certificates",
        "curl",
        "gnupg",
        "lsb-release",
    ]

    $docker_pkgs = [
        "docker-ce",
        "docker-ce-cli",
        "containerd.io",
    ]

    $docker_gpg = "/tmp/docker.gpg"
    $docker_keyring = "/usr/share/keyrings/docker-archive-keyring.gpg"

    package { $prereq: }
    file { $docker_gpg:
        source => "https://download.docker.com/linux/debian/gpg",
    }->
    exec { "/usr/bin/gpg --dearmor -o $docker_keyring $docker_gpg":
        creates => $docker_keyring,
        notify => Exec['apt update'],
    }
    file { "/etc/apt/sources.list.d/docker.list":
        content => "deb [arch=amd64 signed-by=${docker_keyring}] https://download.docker.com/linux/debian $lsbdistcodename stable",
        notify => Exec['apt update'],
        replace => false,
    }

    package { $docker_pkgs: }

    file { '/etc/docker/daemon.json':
        source => 'puppet:///modules/docker/daemon.json',
        owner => 'root', group => 'root', mode => '0644',
    }
}
