# This is quite a hack, but since Debian puts python packages installed with 
#  pip/easy_install into usr local, rather than the python_site_pkg directory, you 
#  basically have to load pip and see where it would put things. 

# Thanks for patching upstream and making it 'better' Debian...and by better, I mean dumb.

Facter.add(:py_location) do

  pycommand = %q{from setuptools.command.easy_install import easy_install
class easy_install_default(easy_install):
  """ class easy_install had problems with the fist parameter not being
      an instance of Distribution, even though it was. This is due to
      some import-related mess.
      """

  def __init__(self):
    from distutils.dist import Distribution
    dist = Distribution()
    self.distribution = dist
    self.initialize_options()
    self._dry_run = None
    self.verbose = dist.verbose
    self.force = None
    self.help = 0
    self.finalized = 0

e = easy_install_default()
import distutils.errors
try:
  e.finalize_options()
except distutils.errors.DistutilsError:
  pass

print e.install_dir
}

  setcode do
    %x{ python -c \'#{pycommand}\' }.strip!
  end
end
