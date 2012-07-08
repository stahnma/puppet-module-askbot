class askbot::params {

  #FIXME obviously these params are too specific for a generic module

  $askbot_site_name = "Puppet Labs"
  $askbot_email = "stahnma@puppetlabs.com"

  # Must be informat of a zoneinfo file (e.g. 'America/Chicago' )
  $askbot_timezone = 'Zulu'

  # Database Settings (assumes Postgresql)
  $askbot_db_name = "askbot"
  $askbot_db_user = "askbot"
  $askbot_db_pass = "askbot"
  $askbot_db_host = "localhost"
  $askbot_db_port = "5432"

  # Mail Settings for askbot

  $askbot_server_email = 'ask@puppetlabs.com'
  $askbot_from_email = 'ask@puppetlabs.com'
  $askbot_email_host_user = 'ask@puppetlabs.com'
  $askbot_email_host_pass = 'XvQKPbDo '
  $askbot_email_subject_prefix = 'Puppet Labs Askbot'
  $askbot_email_host = 'smtp.gmail.com'
  $askbot_email_port = '587'
  $askbot_email_tls = 'True'

  # Generic Params
  case $::osfamily {

    'RedHat': {
      $prereqs = [ 'mod_wsgi' ]
      $webserver = 'httpd'
      $wsgi = 'mod_wsgi'
      $web_user = 'apache'
      $web_group = 'apache'
      $askbot_provider = 'yum'
    }

    'Debian': {
       $prereqs = [ 'python-pip', 'python-dev', 'python-psycopg2'  ]
       $webserver = 'apache2'
       $wsgi = "libapache2-mod-wsgi"
       $web_user = 'www-data'
       $web_group = 'www-data'
       $askbot_provider = 'pip'
     } 
  }

  # Derrived, don't mess with this one
  $askbot_home = "$py_location/askbot"

}
