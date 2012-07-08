class askbot::postgres {

  include 'postgresql'
  include 'postgresql::server'
  #  include 'postgresql::initdb'
  #include 'postgresql::database_user'


   postgresql::db { "askbot":
     user     => 'askbot',
     password => 'askbot',
     grant    => 'all',
     #  require  => Postgresql::Database_user['askbot_user'],
   }


  if $::osfamily == 'RedHat' {
     $dir = '/var/lib/pgsql'
  }
  else { 
     $dir = '/var/lib/postgresql'
  }

  exec { "askbot_db_ownership":
    # command => "createuser --no-superuser --no-createdb --no-createrole --encrypted  askbot",
    command  => "echo \"ALTER DATABASE askbot OWNER TO askbot\" | psql --no-password --tuples-only --quiet",
    require   => [  Postgresql::Db['askbot'] ] ,
    user      => 'postgres',
    logoutput => on_failure,
    cwd       => $dir,
  }


  #    postgresql::database_user { "askbot_user":
  #  user               =>  'askbot',
  #  db                 =>  'askbot',
  #  createdb           =>  false,
  #  #    password_hash =>  postgresql_passowrd('askbot'),
  #  password_hash      =>  'md5f7cda495fd6489ee416306e15e0387f7',
  #  superuser          =>  false,
  #  createrole         =>  false,
  #  #    require            => Postgresql::Db['askbot'],
  #}

  #  postgresql::psql { "db_ownership":
  #  #db => 'askbot',
  #  db  => 'postgres',
  #  user    => 'askbot',
  #  command => "alter database askbot owner to askbot",
  #  require => Postgresql::Db['askbot'],
  #  unless  => "select 1 where 1 = 0"
  #}

  Exec {
    path      => [ '/bin', '/usr/bin', '/sbin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin' ],
  }

  #exec { "create_db_user":
  #  command => "createuser --no-superuser --no-createdb --no-createrole --encrypted  askbot",
  #  unless  => "echo \"SELECT rolname FROM pg_roles WHERE rolname='askbot'\" | psql --no-password --tuples-only --quiet"
  #}

  #exec { "create_askbot_database":
  #  command => "createdb --owner askbot askbot",
  #  unless  => "echo \"SELECT datname FROM pg_database WHERE datname='askbot'\" | psql --no-password --tuples-only --quiet | grep -w askbot",
  #  require => Exec['create_db_user'],
  #}


}

