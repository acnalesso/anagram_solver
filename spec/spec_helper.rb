require File.expand_path "../../../rspec-core/lib/rspec/autorun", __FILE__
SanitizeHelper = Module.new
TagHelper = Module.new

# require 'capybara/rspec'
require 'active_support/concern'
require 'active_support/core_ext/string/inflections'
require 'action_view/helpers/text_helper'
$:.unshift File.expand_path('../../app', __FILE__)

##
# Make tests run faster by not loading Rails.
#

module ActionDispatch
  module Routing
    class Mapper
    end
  end
end

class ApplicationController
  class << self
    attr_reader :extensions
    def respond_to(*extensions)
      @extensions = extensions
    end

    def extensions
      @extensions
    end
  end


  def extensions
    self.class.extensions
  end

end

RSpec.configure do |c|
  c.filter_run_excluding example_group: ->(m) { m[:file_path].include?('dummy') }
end

