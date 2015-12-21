module V1
  module Controllers

    # Base module for common extensions and callbacks
    module Base
      extend ActiveSupport::Concern
      include Praxis::Controller

      included do
        # setup Praxis::Blueprint cache
        before :action do |controller, callee|
          Praxis::Blueprint.cache = Hash.new do |hash, key|
            hash[key] = Hash.new
          end
        end
      end
    end

    def default_encoder
      'json'.freeze
    end

  end
end
