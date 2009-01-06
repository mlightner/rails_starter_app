options = "-Rn"
base = RAILS_ROOT
find = $arg
dirs = "vendor/plugins app db lib test config "

system("cd #{base} && grep #{options} \"#{find}\" #{dirs} | grep -v \\.svn | grep -v \\.git | grep -v \\~\\:")

