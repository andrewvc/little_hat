#!/usr/bin/env ruby

require 'rubygems'
require 'time'
require 'json'
require './acf_invalidate.rb'

puts `ruby -I . generate.rb`
puts "Syncing with S3"
cmd = "s3cmd --acl-public --add-header 'Cache-Control: max-age=1500' --force --progress sync public/ s3://andrewvc.com/"
puts cmd
puts `#{cmd}`

if ARGV[0] == 'invalidate'
  conf = JSON.parse File.open('s3_config.json').read
  puts "Invalidating Cache" 
  dist = Acf.new(conf['distribution_id'], conf['access_key'], conf['secret_access_key'])
  puts dist.invalidate('/','/index.html','/js/main.js', '/images/main-graphic.png','/stylesheets/main.css').inspect
end
puts "Done"
