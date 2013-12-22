# == Class: gdash
#
# Full description of class gdash here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { gdash:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Bill Fraser <fraser@pythian.com>
#
# === Copyright
#
# Copyright 2013 Bill Fraser
#
class gdash (
    $graphite_host   = $gdash::params::graphite_host,
    $gdash_root      = $gdash::params::gdash_root,
) {
    include gdash::params

    class { 'gdash::configure': }

    package { [ 'ruby-devel', 'rubygem-rack' ]:
        ensure      => present,
    }

    package { 'rubygem-redcarpet':
        ensure      => present,
        require     => Package['rubygem-rack']
    }

    package { 'bundler':
        ensure      => present,
        provider    => 'gem',
        require     => Package['ruby-devel'],
    }

    package { 'commonjs':
        ensure      => '0.2.6',
        provider    => 'gem',
        require     => Package['ruby-devel'],
    }

    package { 'graphite_graph':
        ensure      => '0.0.8',
        provider    => 'gem',
        require     => Package['ruby-devel'],
    }

    package { 'json':
        ensure      => '1.7.7',
        provider    => 'gem',
        require     => Package['ruby-devel'],
    }

    package { 'less':
        ensure      => '2.2.1',
        provider    => 'gem',
        require     => Package['ruby-devel'],
    }

    package { 'rack':
        ensure      => '1.4.5',
        provider    => 'gem',
        require     => Package['ruby-devel'],
    }

    package { 'rack-protection':
        ensure      => '1.2.0',
        provider    => 'gem',
        require     => Package['ruby-devel'],
    }

    package { 'sinatra':
        ensure      => '1.3.3',
        provider    => 'gem',
        require     => Package['ruby-devel'],
    }

    package { 'therubyracer':
        ensure      => '0.10.1',
        provider    => 'gem',
        require     => Package['ruby-devel'],
    }

    package { 'tilt':
        ensure      => '1.3.3',
        provider    => 'gem',
        require     => Package['ruby-devel'],
    }

    # Install Git
    package { 'git':
        ensure      => present,
    }

    # Clone GDash Git repository
    vcsrepo { 'gdash':
        ensure          => present,
        path            => $gdash_root,
        provider        => 'git',
        source          => 'https://github.com/ripienaar/gdash.git',
        require         => Package['git'],
    }

    file { "${gdash_root}/config":
        ensure      => directory,
        require     => Vcsrepo['gdash'],
    }

    file { "${gdash_root}/config/gdash.yaml":
        content     => template('gdash/gdash.yaml.erb'),
        group       => 'root',
        owner       => 'root',
        require     => File["${gdash_root}/config"],
    }
}
