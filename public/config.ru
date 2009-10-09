# This file goes in domain.com/config.ru
require 'sinatra/lib/sinatra.rb'
require 'rubygems'
 
Sinatra::Application.default_options.merge!(
  :run => false,
  :env => :production
)
 
require 'admin.rb'
run Sinatra.application
