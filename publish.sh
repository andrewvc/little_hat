#!/bin/sh
./generate.rb
echo "Syncing with S3"
s3cmd --acl-public sync public/ s3://andrewvc.com
echo "Done"
