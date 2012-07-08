class askbot::opinions inherits askbot::params {


  # These files were modified for our usage
  file {   "${askbot_home}/skins/default/templates/instant_notification.html" :
    ensure => present,
    source => "puppet:///modules/askbot/instant_notification.html",
    owner => 0,
    group => 0,
    mode => 0644,
    require => Exec[askbot_build_assets],
#    notify  => Service['httpd'],
  }

  file { "${askbot_home}/skins/default/templates/question/sharing_prompt_phrase.html":
    source => "puppet:///modules/askbot/sharing_prompt_phrase.html",
    ensure => present,
    owner => 0,
    group => 0,
    mode => 0644,
    require => Exec[askbot_build_assets],
#    require => Package[$pkgs],
#    notify  => Service['httpd'],
  }

  # This is specific to Puppet Labs (includes logo and such)
  #FIXME this should be moved out
  file { "$askbot_home/upfiles/ask":
    ensure  => directory,
    recurse => true,
    owner   => $web_user,
    group   => $web_group,
    mode    => 0644,
    source  => "puppet:///modules/askbot/upfiles/ask",
    require => Package['askbot'],
  }


}
