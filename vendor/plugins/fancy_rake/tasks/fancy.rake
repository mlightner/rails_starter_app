require File.dirname(__FILE__) + '/../lib/fancy_rake'

include FancyRake::TaskHelpers


set_subtask_handler(:find, :f, :grep, :locate, :search)
set_subtask_handler(:run_test, :rt, :run, :single_test)

desc "Arbitrary task system."
rule "" do |t|
  prefix, arg = t.name.split(/\:/, 2)
  FancyRake.run_subtask_for_prefix(prefix, arg)
end
