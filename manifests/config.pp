class dotfiles::config(
  $sh                    = $dotfiles::params::sh,
  $zsh                   = $dotfiles::params::zsh,
  $manage_user           = $dotfiles::params::manage_user,
  $set_sh                = $dotfiles::params::set_sh,
  $disable_auto_update   = $dotfiles::params::disable_auto_update,
  $disable_update_prompt = $dotfiles::params::disable_update_prompt,
  $repo_url              = $dotfiles::params::repo_url,
  $plugins               = $dotfiles::params::default_plugins,
  $manage_zsh            = $dotfiles::params::manage_zsh,
  $zsh_package_name      = $dotfiles::params::zsh_package_name,
  $manage_git            = $dotfiles::params::manage_zsh,
  $git_package_name      = $dotfiles::params::git_package_name,
  $theme_username_slug   = $dotfiles::params::theme_username_slug,
  $theme_hostname_slug   = $dotfiles::params::theme_hostname_slug,
) inherits dotfiles::params {

}
