define dotfiles::uninstall(
  $reset_sh = $dotfiles::config::sh,
) {
  include 'dotfiles::config'

  if $name == 'root' {
    $home = '/root'
  } else {
    $home = "${dotfiles::config::home}/${name}"
  }

  if $reset_sh == undef or $reset_sh == true {
    $_reset_sh = $dotfiles::config::reset_sh
  }
  else {
    $_reset_sh = $reset_sh
  }

  exec { "cp -f ${home}/.zshrc.orig ${home}/.zshrc && rm -f ${home}/.zshrc.orig":
    path   => ['/bin', '/usr/bin'],
    user    => $name,
    onlyif => "test -d ${home}/.oh-my-zsh && test -e ${home}/.zshrc-orig"
  }
  ~>
  exec { "cp -f /etc/zsh/newuser.zshrc.recommended ${home}/.zshrc && rm -rf ${home}/.oh-my-zsh":
    path   => ['/bin', '/usr/bin'],
    user    => $name,
    onlyif => "test -d ${home}/.oh-my-zsh && test ! -e ${home}/.zshrc.orig"
  }
  ~>
  file { "${home}/.oh-my-zsh":
    ensure => absent,
  }

  if $_reset_sh {
    if str2bool($dotfiles::config::manage_user) and ! defined(User[$name]) {
      user { "dotfiles::user ${name}":
        name       => $name,
        shell      => $_reset_sh,
      }
    } else {
      User <| title == $name |> {
        shell => $_reset_sh
      }
    }
  }
}
