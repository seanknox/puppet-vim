# Installs vim and vim-pathogen
# This class require that you're .vimrc is managed by puppet

# Examples
#
#   include vim
#   vim::bundle { 'syntastic':
#     source => 'scrooloose/syntastic',
#   }
#
class vim {

  package { 'vim':
    require => Package['mercurial']
  }
  # Install mercurial since the vim brew package don't satisfy the requirement
  package { 'mercurial': }

  # file { ["/Users/${::boxen_user}/.vim",
  #   "/Users/${::boxen_user}/.vim/autoload",
  #   "/Users/${::boxen_user}/.vim/bundle"]:
  #   ensure  => directory,
  #   recurse => true,
  # }

  repository { "/Users/${::boxen_user}/vim-config":
    source => 'neo/vim-config'
  }
  repository { "/Users/${::boxen_user}/vim-config/.vim/vundle.git":
    source => 'gmarik/vundle',
    require => Repository["/Users/${::boxen_user}/vim-config"]
  }

  file { "/Users/${::boxen_user}/.vim":
    audit   => content,
    target  => "/Users/${::boxen_user}/vim-config/.vim",
    require => [
      # File["/Users/${::boxen_user}/.vim"],
      # File["/Users/${::boxen_user}/.vim/autoload"],
      # File["/Users/${::boxen_user}/.vim/bundle"],
        Repository["/Users/${::boxen_user}/vim-config"],
      # Repository["/Users/${::boxen_user}/vim-config/.vim/vundle.git"]
    ]
  }

  # Install vundle
  exec { "load_vundle":
    command => 'vim +BundleInstall +qall 2>&1 >/dev/null',
    require => [
      Repository["/Users/${::boxen_user}/vim-config/.vim/vundle.git"]
    ],
    subscribe => File['/Users/${::boxen_user}/.vim']
  }

  # Install pathogen into .vimrc
  # file_line { 'load_pathogen':
  #   ensure  => present,
  #   line    => 'execute pathogen#infect()',
  #   path    => "/Users/${::boxen_user}/.vimrc",
  #   require => File["/Users/${::boxen_user}/.vimrc"]
  # }
}

