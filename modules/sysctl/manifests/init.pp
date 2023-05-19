class sysctl {
    package { 'procps': }->
    exec { "sysctl update":
        command => "/usr/sbin/sysctl --system",
        refreshonly => true,
    }
}
