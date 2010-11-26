def url_for_photo(photo,size)
  asset_url_for "#{Conf.photos_pub_url}/#{photo.pub_fn_for_size(size)}"
end

def asset_url_for(path)
  cdn_srv_id = path.length % 3
  "http://#{cdn_srv_id}.cdn.andrewvc.com/#{path}"
end

class Array
  def every(count,&block)
    chunks = []
    each_with_index do |item, index|
      chunks << [] if index % count == 0
      chunks.last << item
    end
    chunks
  end
  alias / every
end
