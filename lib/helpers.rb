def url_for_photo(photo,size)
  "#{Conf.photos_pub_url}/#{photo.pub_fn_for_size(size)}"
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
