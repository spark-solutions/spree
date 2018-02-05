module Spree
  class BaseSerializer
    class << self
      def attribute(*attrs)
        @_attributes ||= []
        @_attributes += attrs
      end

      def remove_attribute(*attrs)
        @_attributes ||= []
        @_attributes -= attrs
      end

      def has_one(attr, serializer)
        @_relations ||= { }
        @_relations[attr] = { type: 'one', serializer: serializer }
      end

      def has_many(attr, serializer)
        @_relations ||= { }
        @_relations[attr] = { type: 'many', serializer: serializer }
      end
    end## class << self

    def serialize(object)
      if resource.respond_to?(:each)
        resource.map { |resource| serialize_resource(resource) }
      else
        serialize_resource(resource)
      end
    end

    protected

    def serialize_resource(object)
      new_hash = { }
      self.class.instance_variable_get(:@_attributes)&.each do |attr|
        if self.respond_to? attr
          new_hash[attr] = public_send(attr, object)
        else
          new_hash[attr] = object.public_send(attr)
        end
      end

      self.class.instance_variable_get(:@_relations)&.each do |attr_name, attr_data|
        serializer = attr_data[:serializer]
        many = attr_data[:type] == 'many'

        next unless resource_to_serialize = object.public_send(attr_name)
        new_hash[attr_name] = serializer.new.serialize(resource_to_serialize, collection: many)
      end

      new_hash
    end
  end
end
