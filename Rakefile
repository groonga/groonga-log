require "bundler/gem_tasks"
task :default => :test

desc "Run tests"
task :test do
  task_index = ARGV.index("test")
  if task_index
    run_test_options = ARGV[(task_index + 1)..-1]
  else
    run_test_options = []
  end
  tests_exit_status = ruby("test/run-test.rb", *run_test_options)
  exit(tests_exit_status)
end
