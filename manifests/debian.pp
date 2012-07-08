class askbot::debian {

  include askbot::postgres
  include askbot::httpd

  $pkgs = [ 'python-pip', 'python-dev'  ] 

  package { $pkgs:
    ensure => present,
  }

  package { "askbot":
    ensure => present,
    provider => pip,
    require => Package[$pkgs],
  }

  file { "/etc/askbot":
    ensure => directory,
    require => Package[$pkgs],
  }

  file { "settings.py":
    path => "/etc/askbot/settings.py",
    # this would need to be corrected for RH
    ensure => "$::py_location/askbot/setup_templates/settings.py",
    require => Package[$pkgs],
  }

}
