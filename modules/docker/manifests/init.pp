class docker {
    include apt

    $prereq = [
        "ca-certificates",
        "curl",
        "gnupg",
        "lsb-release",
    ]
    package { $prereq: }

    $docker_gpg_dir = "/etc/apt/keyrings"
    $docker_gpg = "${docker_gpg_dir}/docker.gpg"
    $docker_keyring = "/usr/share/keyrings/docker-archive-keyring.gpg"

    $distro = $facts['os']['distro']['id'] ? { 'Debian' => 'debian', 'Ubuntu' => 'ubuntu' }
    $docker_gpg_source = "https://download.docker.com/linux/${distro}/gpg"

    file { $docker_gpg_dir:
        ensure => directory,
        mode => '0755',
    }->
    file { "$docker_gpg.armor":
        source => $docker_gpg_source,
        mode => '0644',
    }
    ~>
    exec { "/usr/bin/gpg --dearmor --batch --yes -o $docker_gpg $docker_gpg.armor":
        refreshonly => true,
        notify => Exec['apt update'],
    }
    file { "/etc/apt/sources.list.d/docker.list":
        content => "deb [arch=amd64 signed-by=${docker_gpg}] https://download.docker.com/linux/${distro} $lsbdistcodename stable",
        notify => Exec['apt update'],
        replace => false,
    }

}

class docker::ce inherits docker {
    $docker_pkgs = [
        "docker-ce",
        "docker-ce-cli",
        "containerd.io",
    ]

    package { $docker_pkgs: }->
    file { '/etc/docker/daemon.json':
        source => 'puppet:///modules/docker/daemon.json',
        owner => 'root', group => 'root', mode => '0644',
    }
}

class docker::containerd inherits docker {
    $containerd_config = '/etc/containerd/config.toml'

    package { 'containerd.io': }->
    exec { "/usr/bin/containerd config default > $containerd_config":
        creates => $containerd_config,
        notify => Service['containerd'],
    }

    service { 'containerd': enable => true }
}
