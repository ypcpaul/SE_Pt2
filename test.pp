class test {
  package {'vim-enhanced':}
  package {'git':}
  package {'curl':}

  user { 'monitor':
    name => 'monitor',
    ensure => 'present',
    managehome => true,
    home => '/home/monitor',
    shell => '/bin/bash',
  }

  file { 'scriptsdir':
    path => '/home/monitor/scripts',
    ensure => 'directory',
    require => User['monitor'],
  }
}

node 'localhost' {
  include test
}
