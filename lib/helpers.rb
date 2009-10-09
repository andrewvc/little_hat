def url_for_photo(photo,size)
  "#{Conf.photos_pub_url}/#{photo.pub_fn_for_size(size)}"
end
