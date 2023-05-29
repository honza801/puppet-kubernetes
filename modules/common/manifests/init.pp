class common {
    file { '/root/.bash_aliases':
        source => 'puppet:///modules/common/bash_aliases',
        owner => 'root', group => 'root', mode => '0644',
    }
}
