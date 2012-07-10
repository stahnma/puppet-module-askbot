class askbot (
  $prereqs          = $askbot::params::prereqs,
  $web_user         = $askbot::params::web_user,
  $web_group        = $askbot::params::web_group,
  $askbot_provider  = $askbot::params::askbot_provider,
  $askbot_home      = $askbot::params::askbot_home,
  $askbot_webconfig = $askbot::params::askbot_webconfig
) inherits askbot::params {

  include askbot::postgres
  include askbot::httpd
  include askbot::opinions

  # Resource Defaults
  Exec {
    path      => [ "/bin", "/usr/bin", "/sbin", "/usr/sbin" ],
    logoutput => on_failure,
  }

  package { $prereqs:
    ensure => installed,
  }

  package { "askbot":
    ensure   => installed,
    provider => $askbot_provider,
    require  => Package[$prereqs],
  }

  file { "/var/log/askbot":
    ensure  => directory,
    owner   => $web_user,
    group   => $web_group,
    require => Package['askbot'],
  }

  file { "/var/log/askbot/askbot.log":
    owner   => $web_user,
    group   => $web_group,
    mode    => 0644,
    require => Package['askbot'],
  }

  # Allow users to upload files
  # This should be secured in some maner probably
  file { "upfiles":
    path    => "$askbot_home/upfiles",
    ensure  => directory,
    owner   => 0,
    group   => 0,
    mode    => 2755,
    require => Package['askbot'],
  }

  exec { "askbot_syncdb":
    cwd     => "/etc/askbot/sites/ask/config/",
    command => "python manage.py syncdb --noinput",
    require => [  File['upfiles'], Exec['askbot_db_ownership'], ],
  }

  exec { "askbot_migrate_db":
    cwd       => "/etc/askbot/sites/ask/config/",
    command   => "python manage.py migrate askbot",
    require   => [ Exec['askbot_syncdb'] ],
  }

  # Create a directory structure in /etc for sanity
  file { "/etc/askbot": ensure => directory, }
  file { "/etc/askbot/sites": ensure => directory, }
  file { "/etc/askbot/sites/ask": ensure => directory, }
  file { "/etc/askbot/sites/ask/config": ensure => directory, }

  file { "/etc/askbot/sites/ask/config/__init__.py": 
     ensure => present,
     source => "puppet:///modules/askbot/setup_templates/__init__.py",
     owner  => 0,
     group  => 0,
   }

  file { "/etc/askbot/sites/ask/config/urls.py": 
     ensure => present,
     source => "puppet:///modules/askbot/setup_templates/urls.py",
     owner  => 0,
     group  => 0,
   }

  file { "/etc/askbot/sites/ask/config/manage.py":
     ensure => present,
     source => "puppet:///modules/askbot/setup_templates/manage.py",
     owner  => 0,
     group  => 0,
   }

  file { "askbot_webconfig":
    path    => $askbot_webconfig,
    ensure  => present,
    content => template('askbot/webserver_config.erb'),
    require => File['/etc/askbot/sites/ask/config/settings.py'],
    notify  => Service['webserver'],
   }

  file { "/usr/sbin/askbot.wsgi":
     ensure => present,
     owner  => 0,
     group  => 0,
     mode   => 0755,
     source => "puppet:///modules/askbot/askbot.wsgi",
  }

   exec { "askbot_build_assets":
     cwd     => "/etc/askbot/sites/ask/config/",
     command => "yes yes | python manage.py collectstatic",
     require => [ Exec['askbot_syncdb'], Exec['askbot_migrate_db'] ],
   }

  exec { "askbot_add_auth":
    cwd     => "/etc/askbot/sites/ask/config/",
    command => "python manage.py migrate django_authopenid",
    require => [ Exec['askbot_migrate_db'] ],
  }

  file { "/etc/askbot/sites/ask/config/settings.py":
    ensure  => present,
    content => template('askbot/settings.erb'),
    owner   => $web_user,
    group   => $web_group,
    mode    => 0640,
    require => File["/etc/askbot/sites/ask/config"],
    notify  => Service['webserver'],
  }

}
