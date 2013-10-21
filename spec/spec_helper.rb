$:.push File.expand_path('../../app', __FILE__)
##
# Make tests run faster by not loading Rails.
#
ApplicationController = Class.new
