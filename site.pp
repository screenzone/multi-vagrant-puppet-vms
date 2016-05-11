node default {
# Test message
  notify { "Debug output on ${hostname} node.": }

  include ntp, git
}

node 'node01.vm.local', 'node02.vm.local' {
# Test message
  notify { "Debug output on ${hostname} node.": }

  include ntp, git, docker, fig
}