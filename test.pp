class test {
  $mypackages = ['vim-enhanced', 'git', 'curl', 'wget']

  package { $mypackages: ensure => 'installed' }

  user { 'monitor':
    name => 'monitor',
    ensure => 'present',
    managehome => true,
    home => '/home/monitor',
    shell => '/bin/bash',
    require => Package [$mypackages],
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

  file {
    'srcdir':
      path => '/home/monitor/src',
      ensure => 'directory',
      require => File['/home/monitor/scripts/memory_check.sh'],
    ;
    '/home/monitor/src/my_memory_check.sh':
      path => '/home/monitor/src/my_memory_check.sh',
      ensure => 'link',
      require => [ File['srcdir'], File['/home/monitor/scripts/memory_check.sh'] ],
      target => '/home/monitor/scripts/memory_check.sh'
  }

  cron { 'memory_check':
    command => '/home/monitor/src/my_memory_check.sh',
    user => 'root',
    minute => 10,
    hour => absent,
    month => absent,
    monthday => absent,
    weekday => absent,
    require => File['/home/monitor/src/my_memory_check.sh'],
  }
}

node 'localhost' {
  include test
}
