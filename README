askbot
------
This module sets up askbot as the primary URL for the host at / using apache's httpd server in conjunction with mod_wsgi.
See http://askbot.org

Known Issues
-------
* You need stdlib  (> 2.3.3) (not released as of 07-07-2012)
* cprice-postgresql [ branch: feature/master/align-with-puppetlabs-mysql ] (with a patch I just submitted)
* stdlib and cprice-postgresql are not on the forge with the patches we need currently
* There is no hiera integration, it's all in params.pp

Limitations
-------
* On EL, this modules assumes you have EPEL configured (why wouldn't you). It also does not attempt to modify IPtables for you.
* Only tested in Centos6 and Debian Wheezy
* The opinions file is kind of specific to a test instance I ran

License
-------
ASL 2.0


Contact
-------
stahnma@puppetlabs.com

Support
-------
https://github.com/stahnma/puppet-module-askbot/issues
