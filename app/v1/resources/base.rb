module V1
  module Resources
    class Base < Praxis::Mapper::Resource
      def href
        V1::ResourceDefinitions.const_get(model.name.pluralize).to_href(id: self.id)
      end

      def timestamps
        @timestamps ||= begin
          return {} if record.timestamps.nil?
          [:created_at, :updated_at].each_with_object({}) do |key, hash|
            value = record.timestamps[key] || record.timestamps[key.to_s]
            next unless value
            hash[key] = DateTime.parse(value)
          end
        end
      end


    end
  end
end
