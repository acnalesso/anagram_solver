require 'active_support/concern'
$:.unshift File.expand_path('../../app', __FILE__)

##
# Make tests run faster by not loading Rails.
#
ApplicationController = Class.new

module ActionDispatch
  module Routing
    class Mapper
    end
  end
end
