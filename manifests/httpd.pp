class askbot::httpd (
  $wsgi      = $askbot::params::wsgi,
  $webserver = $askbot::params::webserver,
) inherits askbot::params {

  # It's called mod_wsgi on EL based systems
  # libapache2-mod-wsgi on debian stuff

  package { $wsgi:
    ensure => present,
  }

  package { "webserver":
    name    => $webserver,
    ensure  => present,
    require => Package[$wsgi],
  }

  service { "webserver":
    ensure  => running,
    enable  => true,
    name    => $webserver,
    require => [ Package['webserver'], Exec[askbot_build_assets] ] ,
  }

}
