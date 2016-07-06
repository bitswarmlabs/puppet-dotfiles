class dotfiles::params {
  $disable_auto_update = false
  $disable_update_prompt = false

  $manage_zsh = true
  $zsh_package_name = 'zsh'

  $manage_git = true
  $git_package_name = 'git'

  $manage_user = true

  case $::osfamily {
    'Redhat': {
      $zsh = '/bin/zsh'
      $sh = $zsh
      $reset_sh = '/bin/bash'
      $os_default_plugins = [
        'fedora'
      ]
    }
    'Debian': {
      $zsh = '/usr/bin/zsh'
      $sh = $zsh
      $reset_sh = '/bin/bash'
      if $::operatingsystem == 'Ubuntu' {
        $os_default_plugins = [
          'ubuntu'
        ]
      }
      else {
        $os_default_plugins = [
          'debian'
        ]
      }
    }
    default: {
      $zsh = '/usr/bin/zsh'
      $sh = $zsh
      $reset_sh = '/bin/bash'
      $os_default_plugins = []
    }
  }

  $default_plugins = concat($os_default_plugins, $environment_default_plugins)

  $home = '/home'

  $repo_url = 'https://github.com/bitswarmlabs/dotfiles.git'

  $theme_username_slug = '%n'
  $theme_hostname_slug = '%m'
}
