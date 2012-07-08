class askbot::el {

  # I assume you already have something else that will do mod_wsgi
  include askbot::postgres
  include askbot::httpd
  include askbot::params

  $pkgs = [ 'askbot' ]

  package { $pkgs:
    ensure => installed,
    require => Class[::askbot::httpd],
  }

  # Config file
  file { "/etc/askbot/sites/ask/config/settings.py":
    ensure => present,
    source => "puppet:///modules/askbot/settings.py",
    owner => 'apache',
    group => 'apache',
    mode => 0640,
    require => Package[$pkgs],
    notify  => Service['httpd'],
  }

  file { "/var/log/askbot/askbot.log":
    ensure => present,
    owner  => apache,
    group  => apache,
    mode   => 0644,
    require => Package[$pkgs],
  }

  # There is fact included in this module for python_site_pkg dir

  # These files were modified for our usage
  file {   "${::python_site_pkg}/askbot/skins/default/templates/instant_notification.html" :
    ensure => present,
    source => "puppet:///modules/askbot/instant_notification.html",
    owner => 0,
    group => 0,
    mode => 0644,
    require => Package[$pkgs],
    notify  => Service['httpd'],
  }

  file { "${::python_site_pkg}/askbot/skins/default/templates/question/sharing_prompt_phrase.html":
    source => "puppet:///modules/askbot/sharing_prompt_phrase.html",
    ensure => present,
    owner => 0,
    group => 0,
    mode => 0644,
    require => Package[$pkgs],
    notify  => Service['httpd'],
  }

  file { "/var/lib/askbot/upfiles":
    ensure => directory,
    owner => 0,
    group => 0,
    mode => 0755,
    require => Package[$pkgs],
  }

  exec { "askbot_syncdb":
    cwd     => "/etc/askbot/sites/ask/config/",
    command => "python manage.py syncdb --noinput",
    require => [ File['/var/lib/askbot/upfiles'],
    #Postgresql::Database_user["askbot_user"],
    #             Postgresql::DB["askbot"],
                  Exec['askbot_db_ownership'],
               ],
    notify  => Service['httpd'],
    logoutput => on_failure,

  }

  exec { "askbot_migrate_db":
    cwd       => "/etc/askbot/sites/ask/config/",
    command   => "python manage.py migrate askbot",
    require   => [ Exec['askbot_syncdb'] ],
    notify    => Service['httpd'],
    logoutput => on_failure,
  }

  exec { "askbot_add_auth":
    cwd       => "/etc/askbot/sites/ask/config/",
    command   => "python manage.py migrate django_authopenid",
    require   => [ Exec['askbot_migrate_db'] ],
    notify    => Service['httpd'],
    logoutput => on_failure,
  }

  file { "/var/lib/askbot/upfiles/ask":
    ensure  => directory,
    recurse => true,
    owner   => 'apache',
    group   => 'apache',
    mode    => 0644,
    source  => "puppet:///modules/askbot/upfiles/ask",
    require => Package[$pkgs],
  }


  service { "httpd":
    ensure  => running,
    enable  => true,
    require => Package[webserver],
  }

  Exec {
    path     => [ '/bin', '/usr/bin', '/sbin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin' ],
  }


}
