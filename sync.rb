#!/usr/bin/env ruby

require 'rubygems'
require 'time'
require 'json'
require './acf_invalidate.rb'

puts `./generate.rb`
puts "Syncing with S3"
expires = (Time.now).httpdate
cmd = "s3cmd --acl-public --add-header 'Expires: #{expires}' --force --progress sync public/ s3://andrewvc.com/"
puts cmd
puts `#{cmd}`

if ARGV[0] == 'invalidate'
  conf = JSON.parse File.open('s3_config.json').read
  puts "Invalidating Cache" 
  dist = Acf.new(conf['distribution_id'], conf['access_key'], conf['secret_access_key'])
  puts dist.invalidate('/','/index.html','/js/main.js', '/images/main-graphic.png','/stylesheets/main.css').inspect
end
puts "Done"
