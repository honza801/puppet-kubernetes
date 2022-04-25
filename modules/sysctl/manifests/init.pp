class sysctl {
    package { 'procps': }->
    exec { "sysctl update":
        command => "/usr/bin/sysctl --system",
        refreshonly => true,
    }
}
