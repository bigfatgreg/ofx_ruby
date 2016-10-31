require "bundler/gem_tasks"
require "rake/testtask"
require "dotenv"
Dotenv.load

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

task :default => :test

namespace :drone do
  desc 'Generate the encrypted drone secrets file.'
  task :sec do
    `DRONE_SERVER=#{ENV['DRONE_SERVER']} DRONE_TOKEN=#{ENV['DRONE_TOKEN']} \
    drone secure --in .drone.sec.yml --repo #{ENV['DRONE_REPO']}`

    puts 'generated .drone.sec.yml!'
  end

  desc 'Run the drone build locally'
  task :test do
    `drone exec -E .drone.sec.yml --trusted --debug --notify 2>&1`
  end
end
