#Setup the configuration object
require 'singleton'
require 'ostruct'
class Conf < OpenStruct
  include Singleton
  def self.method_missing(meth,*args)
    self.instance.send(meth,*args)
  end
end
