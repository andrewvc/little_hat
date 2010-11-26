#!/usr/bin/env ruby
#Configure in settings.rb

#Gems
require 'rubygems'
require 'haml'
require 'yaml'
require 'net/http'
require 'simple-rss'
require 'open-uri'
require 'term/ansicolor'
require 'json'

#Custom libs
require 'lib/conf'
require 'settings'
require 'lib/photo'
require 'lib/helpers'

include Term::ANSIColor

def main
  puts bold { "Generating Photos" }
  pres = proc_photos
  @photos, @photos_by_cat = pres[:photos], pres[:photo_by_cat]
  puts bold { "Pulling Blog RSS" }
  @blog_posts   = get_rss
  puts bold { "Rendering" }
  render_haml
  puts bold { green { "Done" } }
end

def proc_photos
  errors = []
  photo_db = YAML::load_file(Conf.photo_db)  

  photos = []
  photos_by_cat = {} 
  generated_thumbs = []
  photo_db.each do |cat,cat_photos|
    photos_by_cat[cat] = []
    cat_photos.each do |precord|
      pfilename, ptitle = precord
      begin
        photo = Photo.new(pfilename,ptitle)
        photos_by_cat[cat] << photo
        generated = photo.make_all_missing_published_sizes
      rescue Exception => e
        puts red { e.message }
      end
      generated_thumbs << generated unless generated.nil? || generated.empty?
    end
  end
  photos = photos_by_cat.inject([]) {|pflat,cat| cat[1].each {|v| pflat << v}}
  {:photos => photos, :photos_by_cat => photos_by_cat}
end


def get_rss
  rss = SimpleRSS.parse open(Conf.blog_feed_url)
  rss.items.map do |item| 
    {:title => item.title, :link => item.link, :description => item.description}
  end
end

def render_haml
  index = Haml::Engine.new(File.open('index.haml').read)
  File.open('public/index.html', 'w') do |f|
   f.write index.render(self)
  end
end

main
