#!/usr/bin/env ruby

require 'time'

puts `./generate.rb`
puts "Syncing with S3"
expires = (Time.now + (60*60)).httpdate
cmd = "s3cmd --acl-public --add-header 'Expires: #{expires}' --force --progress sync public/ s3://andrewvc.com/"
puts cmd
puts `#{cmd}`
puts "Done"
