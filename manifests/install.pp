define dotfiles::install(
  $set_sh = $dotfiles::config::sh,
) {
  include 'dotfiles'
  include 'dotfiles::config'
  include 'ruby::dev'


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

  anchor { "dotfiles:install:${name}:begin": }
  ->
  exec { "dotfiles:yadr:${name} git clone ":
    creates   => "${home}/.yadr",
    cwd       => $home,
    command   => "git clone --depth=1 ${dotfiles::config::repo_url} ${home}/.yadr || (rmdir ${home}/.yadr && exit 1)",
    path      => ['/bin', '/usr/bin', '/usr/local/bin'],
    onlyif    => "test ! -d ${home}/.yadr && getent passwd ${name} | cut -d : -f 6 | xargs test -e",
    user      => $name,
    require   => Package[$dotfiles::config::git_package_name],
    logoutput => true,
  }
  ~>
  exec { "backup ${name} zshrc":
    command     => "cp -f ${home}/.zshrc ${home}/.zshrc.orig",
    path        => ['/bin', '/usr/bin'],
    user        => $name,
    onlyif      => "test -e ${home}/.zshrc",
    refreshonly => true,
    require     => File["${home}/.zshrc"]
  }
  ~>
  ruby::rake { "dotfiles:yadr:${name} rake install":
    cwd         => "${home}/.yadr",
    task        => "install",
    user        => $name,
    environment => [ "HOME=${home}" ],
    creates     => "${home}/.yadr-installed",
    require     => File["${home}/.zshrc"],
  }
  ~>
  exec { "echo `date` > ${home}/.yadr-installed":
    cwd         => $home,
    path        => '/bin',
    user        => $name,
    refreshonly => true,
  }
  ->
  Anchor["dotfiles:install:${name}:end"]

  file { "${home}/.zshrc":
    ensure  => present,
    source  => '/etc/zsh/newuser.zshrc.recommended',
    owner   => $name,
    group   => $name,
    replace => false,
  }

  if $_set_sh {
    if str2bool($dotfiles::config::manage_user) and ! defined(User[$name]) {
      user { "dotfiles::user ${name}":
        ensure     => present,
        name       => $name,
        managehome => true,
        shell      => $dotfiles::config::zsh,
        require    => Package[$dotfiles::config::zsh_package_name],
      }
      ~>Anchor["dotfiles:install:${name}:end"]
    } else {
      User <| title == $name |> {
        shell => $dotfiles::config::zsh
      }
    }
  }

  anchor { "dotfiles:install:${name}:end": }
}
