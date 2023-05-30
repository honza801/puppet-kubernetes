class common {
    File {
        owner => 'root', group => 'root', mode => '0644',
    }

    file { '/root/.bash_aliases':
        source => 'puppet:///modules/common/bash_aliases',
    }
    file { '/root/.vimrc':
        source => 'puppet:///modules/common/vimrc',
    }
    file { '/etc/localtime': target => '/usr/share/zoneinfo/Europe/Prague' }
}
