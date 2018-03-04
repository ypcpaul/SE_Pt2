class test {
  package {'vim-enhanced':}
  package {'git':}
  package {'curl':}
  package {'wget':}

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

  exec { 'fetch_from_gh':
    command => '/usr/bin/wget -q https://raw.githubusercontent.com/ypcpaul/SE_Pt1/master/memory_check.sh -O /home/monitor/scripts/memory_check.sh',
    creates => '/home/monitor/scripts/memory_check.sh',
    require => [ File['scriptsdir'], Package['wget'] ],
  }

  file { '/home/monitor/scripts/memory_check.sh':
    ensure => 'file',
    require => Exec['fetch_from_gh'],
    mode => 0755,
  }
}

node 'localhost' {
  include test
}
