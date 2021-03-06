# frozen_string_literal: true

require 'rparam/railtie'
require 'rparam/controller'
require 'rparam/date_ext'
require 'rparam/memory'
require 'rparam/model'
require 'rparam/parameter'
require 'rparam/parser'
require 'rparam/transformer'
require 'rparam/calculator'

module Rparam
  # Your code goes here...
end

ActiveSupport.on_load(:action_controller) do
  include Rparam::Controller
end

ActiveSupport.on_load(:active_record) do
  include Rparam::Model
end
