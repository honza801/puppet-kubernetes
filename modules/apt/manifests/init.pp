class apt {
    exec { "apt update":
        command => "/usr/bin/apt update -qq",
        refreshonly => true,
    }->Package<||>
}
