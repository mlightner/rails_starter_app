# rt:partial_test_name
testdir = RAILS_ROOT + '/test'
test_name = $arg
run_file_name = `grep -Rl '#{test_name}' #{testdir}/unit #{testdir}/functional #{testdir}/integration | grep -v \.svn | grep -v \\~`.split(/[\r\n]/, 2).first
raise "Can't find test #{test_name}" unless run_file_name =~ /\S/

if test_name && run_file_name
  puts "CLEARING: test log files..."
  %w( test.log domain_registry.log debug.log ).each do |file|
    local_run("echo -n > #{testdir}/../log/#{file}")
  end
  local_run("ruby -Ilib:test #{run_file_name} --name='test_#{test_name}'")
end
