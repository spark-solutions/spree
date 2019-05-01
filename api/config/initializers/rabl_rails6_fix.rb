# Rails 6.X Template
module ActionView
  module Template::Handlers
    class Rabl
      class_attribute :default_format, default: :json

      def self.call(template, source)
        %{ ::Rabl::Engine.new(#{source.inspect}).
            apply(self, assigns.merge(local_assigns)).
            render }
      end # call
    end # rabl class
  end # handlers
end

ActionView::Template.register_template_handler :rabl, ActionView::Template::Handlers::Rabl
