#!/usr/bin/ruby
#Configure in settings.rb

#Gems
require 'rubygems'
require 'sinatra'
require 'erb'
require 'yaml'

#Custom libs
require 'lib/conf'
require 'settings'
require 'lib/photo'
require 'lib/helpers'

def proc_photos
  #Load the database of photos and instantiate them
  return photos 
end

get '/' do 
  unless File.exists? Conf.photo_cache
    raise "Cache not populated, run a regen first (see README)"
  end
  cache = YAML::load_file Conf.photo_cache

  @photos = cache[:photos]
  @photos_by_cat = cache[:photos_by_cat]

  erb :index
end

get '/admin' do
  @errors = []
  photo_db = YAML::load_file(Conf.photo_db)  

  @photos = []
  @photos_by_cat = {} 
  @generated_thumbs = []
  photo_db.each do |cat,cat_photos|
    @photos_by_cat[cat] = []
    cat_photos.each do |pf|
      begin
        photo = Photo.new(pf)
        @photos_by_cat[cat] << photo
        generated = photo.make_all_missing_published_sizes
      rescue Exception => e
        @errors << "#{e.message},#{e.backtrace}"
      end
      @generated_thumbs << generated unless generated.nil? || generated.empty?
    end
  end

  #Make a flat list of photos as well
  @photos = @photos_by_cat.inject([]) {|pflat,cat| cat[1].each {|v| pflat << v}}
  
  #Cache this data for use by the index view
  cache = {:photos => @photos, :photos_by_cat => @photos_by_cat}
  File.open(Conf.photo_cache, 'w') {|f| f.write cache.to_yaml}
  
  erb :admin
end
