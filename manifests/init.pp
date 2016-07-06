# Class: dotfiles
# ===========================
#
# Full description of class dotfiles here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'dotfiles':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class dotfiles(
  $manage_zsh      = 'UNSET',
  $manage_git      = 'UNSET'
) inherits dotfiles::params {
  include 'dotfiles::config'

  $_manage_zsh = $manage_zsh ? {
    'UNSET' => $dotfiles::config::manage_zsh,
    default => $manage_zsh,
  }

  $_manage_git = $manage_git ? {
    'UNSET' => $dotfiles::config::manage_git,
    default => $manage_git,
  }


  anchor { 'dotfiles::begin': }

  if str2bool($_manage_zsh) {
    if ! defined(Package[$dotfiles::config::zsh_package_name]) {
      package { $dotfiles::config::zsh_package_name:
        ensure => present,
      }
      ~>Anchor['dotfiles::end']
    }
  }

  if str2bool($_manage_git) {
    if ! defined(Package[$dotfiles::config::git_package_name]) {
      package { $dotfiles::config::git_package_name:
        ensure => present,
      }
      ~>Anchor['dotfiles::end']
    }
  }

  anchor { 'dotfiles::end': }
}
