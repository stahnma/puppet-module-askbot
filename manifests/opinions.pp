class askbot::opinions inherits askbot::params {

    # These files were modified for our usage
    file {   "${askbot_home}/skins/default/templates/instant_notification.html" :
        ensure  => present,
        source  => "puppet:///modules/askbot/instant_notification.html",
        owner   => 0,
        group   => 0,
        mode    => 0644,
        require => Exec[askbot_build_assets],
    }

    # This remove the GIANT "SHARE ALL TEH THINGS WITH THIS QUESTION" text
    # Before this change, it asks you at least 3 times to share things on the tweeterfish,
    # facebooken, and others
    file { "${askbot_home}/skins/default/templates/question/sharing_prompt_phrase.html":
        source  => "puppet:///modules/askbot/sharing_prompt_phrase.html",
        ensure  => present,
        owner   => 0,
        group   => 0,
        mode    => 0644,
        require => Exec[askbot_build_assets],
    }

    # This is specific to Puppet Labs (includes logo and such)
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
