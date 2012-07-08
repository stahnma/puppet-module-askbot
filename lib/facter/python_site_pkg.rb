Facter.add(:python_site_pkg) do
  setcode do
    %x{python -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())"}.strip!
  end
end
