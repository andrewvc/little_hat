require 'rubygems'
require 'sinatra'

Sinatra::Application.default_options.merge!(
  :run => false,
  :env => :production,
  :raise_errors => true,
  :app_file => 'app.rb'
)

log = File.new("sinatra.log", "a") 
$stdout.reopen(log) 
$stderr.reopen(log) 

require 'app'
run Sinatra::Application
