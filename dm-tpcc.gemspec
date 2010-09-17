# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'tpcc/version'

Gem::Specification.new do |s|	
 s.name	   = "dm-tpcc"
 s.version = DataMapper::TPCC::VERSION
 s.authors = ["Ivan R. Judson"]
 s.email   = ["irjudson@gmail.com"]
 s.homepage = "http://github.com/irjudson/dm-tpcc"
 s.summary = "Performance analysis tools for databases using the DataMapper ORM."
 s.description = "DM-TPCC provides an implementation of the TPC-C Specification that lives above the ORM layer to provide two analysis': 1) ORM vs non-ORM performance and 2) comparative performance of databases abstracted via the ORM."

 s.required_rubygems_version = ">= 1.3.6"
 s.rubyforge_project = "dm-tpcc"

 s.files = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.rdoc)
 s.executables  = ['dm-tpcc']
 s.require_path = 'lib'
end