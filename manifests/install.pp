define dotfiles::install(
  $set_sh = $dotfiles::config::sh,
) {
  include 'dotfiles'
  include 'dotfiles::config'

  if $set_sh == undef or $set_sh == true {
    $_set_sh = $dotfiles::config::sh
  }
  else {
    $_set_sh = $set_sh
  }

  if $name == 'root' {
    $home = '/root'
  } else {
    $home = "${dotfiles::config::home}/${name}"
  }

  exec { "dotfiles::git clone ${name}":
    creates => "${home}/.dotfiles",
    command => "git clone --depth=1 ${dotfiles::config::repo_url} ${home}/.yadr || (rmdir ${home}/.yadr && exit 1)",
    path    => ['/bin', '/usr/bin', '/usr/local/bin'],
    onlyif  => "getent passwd ${name} | cut -d : -f 6 | xargs test -e",
    user    => $name,
    require => Package[$dotfiles::config::git_package_name],
  }
  ~>


  exec { 'backup zshrc':
    cmd     => "cp -f ${home}/.zshrc ${home}/.zshrc.orig",
    path    => ['/bin', '/usr/bin'],
    onlyif  => "test ! -d ${home}/.yadr && test -e ${home}/.zshrc"
  }
  # ~>
  # exec { "dotfiles::cp .zshrc ${name}":
  #   creates => "${home}/.zshrc",
  #   command => "cp ${home}/.yadr/templates/zshrc.zsh-template ${home}/.zshrc",
  #   path    => ['/bin', '/usr/bin'],
  #   onlyif  => "getent passwd ${name} | cut -d : -f 6 | xargs test -e",
  #   user    => $name,
  #   require => Exec["dotfiles::git clone ${name}"],
  #   before  => File_line["dotfiles::disable_auto_update ${name}"],
  # }

}
