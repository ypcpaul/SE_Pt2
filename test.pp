class test {
  notify {'Packages':}
  package {'vim-enhanced':}
  package {'git':}
  package {'curl':}
  notify {'Done with packages':}
}

node 'localhost' {
  include test
}
