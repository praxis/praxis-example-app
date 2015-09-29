module V1
  module Controllers

    # Base module for common extensions and callbacks
    module Base
      extend ActiveSupport::Concern
      include Praxis::Controller

      module ClassMethods
        # The media_type for the ResourceDefinition implemented
        # by this Controller
        def media_type
          definition.media_type
        end

        # The identifier string for this Controller's media_type
        def content_type
          media_type.identifier
        end
      end

      included do

        # setup Praxis::Blueprint cache
        before :action do |controller, callee|
          Praxis::Blueprint.cache = Hash.new do |hash, key|
            hash[key] = Hash.new
          end
        end

        # Ensure we call #release on any identity map
        # that may be set by the controller after the action
        # completes.
        around :action do |controller, callee|
          begin
            callee.call
          ensure
            if @identity_map
              @identity_map.release
            end
          end
        end

      end

      # Lazily-initialized reader for a Praxis::Mapper::IdentityMap
      def identity_map
        @identity_map ||= Praxis::Mapper::IdentityMap.new
      end

      def media_type
        self.class.media_type
      end

      def content_type
        self.class.content_type
      end

    end
  end
end
