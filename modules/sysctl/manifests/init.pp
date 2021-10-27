class sysctl {
    exec { "sysctl update":
        command => "/usr/bin/sysctl --system",
        refreshonly => true,
    }
}
