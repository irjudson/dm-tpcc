begin
  require 'bundler'
  Bundler.setup
rescue LoadError
  puts "Bundler is not installed. Install with: gem install bundler"
end

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name        = %q{dm-tpcc}
  gem.authors     = ["Ivan R. Judson"]
  gem.description = %q{DataMapper ORM Performance Measurement tool.}
  gem.email       = %q{irjudson@gmail.com}
  gem.homepage    = %q{http://github.com/irjudson/dm-tpcc}
  gem.summary     = %q{A small set of tools to measure and compare the performance of different data storage systems through the DataMapper ORM.}
  gem.add_dependency(%q<sinatra>         )
  gem.add_dependency(%q<data_mapper>     )
  gem.add_dependency(%q<dm-sweatshop>    )
  gem.add_dependency(%q<dm-is-list>      )
  gem.add_dependency(%q<dm-is-versioned> )
  gem.add_dependency(%q<haml>            )
  # Adapters you want to test: postgres, mysql, persevere, sqlite, and the REST adapter are preloaded.
  # On Ubuntu sudo apt-get install libsqlite3-dev
  gem.add_dependency(%q<dm-postgres-adapter> )
  # On Ubuntu: sudo apt-get install libmysqlclient-dev
  gem.add_dependency(%q<dm-mysql-adapter> )
  # Install and run persevere: http://www.persvr.org
  gem.add_dependency(%q<dm-persevere-adapter> )
  # This should be findable and usable on most systems
  gem.add_dependency(%q<dm-sqlite-adapter> )
  # This comes from DataMapper, you'll need to configure a REST data source for testing.
  gem.add_dependency(%q<dm-rest-adapter> )
  # For the client to work
  gem.add_dependency(%q<rest-client>)
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "dm-tpcc #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
