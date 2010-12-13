require 'rcov/rcovtask'

desc "default rake task"
task :default => :test

desc "run tests"
task :test do
  require 'rake/runtest'
  Rake.run_tests 'test/*.rb'
end

Rcov::RcovTask.new do |t|
  t.test_files = FileList['test/test_*.rb']
  t.verbose = true
  t.output_dir = "coverage"
end
