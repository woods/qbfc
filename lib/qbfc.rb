require 'win32ole'
require 'time'

# ActiveSupport is used for camelize, singularize and similar String inflectors.
unless Object.const_defined?(:ActiveSupport)
  gem 'activesupport'
  require 'active_support'
end

module QBFC
  VERSION = '0.3.0'
  
  class << self
  
    # Opens and yields a QBFC::Session
    def session(*args, &block)
      QBFC::Session::open(*args, &block)
    end
  
    # Generate classes.
    # - +names+: Array of class names.
    # - +superclass+: Superclass of classes to be generated.
    # - +includes+: hash of Module => names of classes to include this module.
    def generate(names, superclass, include_modules = {})
      names.each do | class_name |
        const_set(class_name, Class.new(superclass))
      end
      
      include_modules.each do | mod, classes |
        classes.each do | class_name |
          const_get(class_name).__send__(:include, mod)
        end
      end
    end
    
  end
end

%w{ ole_wrapper qbfc_const session request base element info report qb_collection qb_types }.each do |file|
  require 'qbfc/' + file
end
