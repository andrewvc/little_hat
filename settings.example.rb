#Config 
Conf.photos_dir = 'orig_photos'
#Where the list of photos is stored
Conf.photo_db = 'order.yaml'
#Where resized and web-accessible photos go
Conf.photos_pub     = 'public/photos'
Conf.photos_pub_url = 'photos' 
#Geometries to output and names for said resolutions
Conf.sizes = {
  :index => 'x30',
  :large => '1000x700'
}

#How resized photos are to be named
Conf.gen_pub_photo_fn = Proc.new do |photo_fn,size_name|
  photo_name = photo_fn[0...-File.extname(photo_fn).length]
  "#{photo_name}_#{size_name}.jpg"
end
#Possible values are :rmagick, :convert or :auto (gives rmagick priority)
Conf.user_resize_method	= :auto 
#Path to convert executable
Conf.convert_exec = '/usr/bin/env convert'

#Where the cache of photo data lives
Conf.photo_cache = 'tmp/photos.yaml'

#Logic for the auto resize method detect option
#Possibly does not belong in configuration file... or does it?

#See if rmagick is available
begin
  require('rmagick')
  rmagick_available = true
rescue LoadError => e
  rmagick_available = false
end

#Determine which image resizing methods are available to us
if rmagick_available && Conf.user_resize_method != :convert
  Conf.resize_method = :rmagick
elsif `#{Conf.convert_exec}` && Conf.user_resize_method != :rmagick
  Conf.resize_method = :convert
else
  raise "No suitable tools for image resizing have been found" +
        "for Conf.user_resize_method = '#{Conf.user_resize_method}'"
end
