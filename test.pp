class test {
  package {'vim-enhanced':}
  package {'git':}
  package {'curl':}

  user {'monitor':
    name => 'monitor',
    ensure => 'present',
    managehome => true,
    home => '/home/monitor',
    shell => '/bin/bash',
  }
}

node 'localhost' {
  include test
}
