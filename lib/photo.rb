class Photo
  attr_reader :filename, :filepath

  def initialize(fn)
    @filename = fn
    @filepath = File.join(Conf.photos_dir,@filename)
    raise "'#{@filepath}' does not exist!" unless File.exists?(@filepath)
    raise "'#{@filepath}' is a directory not a photo!" if File.directory?(@filepath)
  end
  
  #Returns an array of which sizes are published
  def published_sizes
    Conf.sizes.keys.find_all {|sn| has_size?(sn)}
  end
  
  #Which publishable sizes is this photo missing
  def missing_published_sizes
    Conf.sizes.keys.reject {|sn| has_size?(sn)}
  end
  
  #Returns true if we have a file for this size
  def has_size?(size_name)
    File.exists?(pub_path_for_size(size_name))
  end
  
  #Returns the pub fn for a given size by calling Conf.gen_pub_photo_fn
  def pub_fn_for_size(size_name)
    Conf.gen_pub_photo_fn.call(@filename,size_name)
  end
  
  #Full path to pub file name for a given size
  def pub_path_for_size(size_name)
    File.join(Conf.photos_pub,pub_fn_for_size(size_name))
  end
  
  #Makes all missing sizes of published photos
  def make_all_missing_published_sizes
          make_sizes(missing_published_sizes)
  end

  def make_all_sizes
    make_sizes(Conf.sizes.keys)
  end

  def make_sizes(sizes)
    sizes.map {|size| make_size(size)}
  end
  
  #Makes a given image size, overwriting any pre-existing files
  def make_size(size_name)
    out_fn    = pub_path_for_size(size_name)
    size_geo  = Conf.sizes[size_name]
    
    if Conf.resize_method == :convert
      `convert #{@filepath} -geometry '#{size_geo}' #{out_fn}`
    elsif Conf.resize_method == :rmagick
      img = Magick::Image.read(@filepath).first
      img.change_geometry!(size_geo) { |cols, rows, img|
        img.resize!(cols, rows)
      }
      img.write(out_fn)
      GC.start #Since Image Magick doesn't work w/ ruby memory management
    else
      raise "Unknown resize method "
    end
    
    out_fn
  end
end
