module Spree
  module CartPromotion
    class HandleOperation < BaseOperation
      attr_accessor :activate, :deactivate

      # Initializes CartPromotion::HandleOperation with activate/deactivate operations passed as params
      #
      # @param activate [BaseOperation] operation to be called to activate promotion
      # @param deactivate [BaseOperation] operation to be called to deactivate promotion
      def initialize(activate: Spree::ActivatePromotionOperation.new,
                     deactivate: Spree::DeactivatePromotionOperation.new)
        @activate = activate
        @deactivate = deactivate
      end

      # Iterates over called of promotions and activates/deactivates specific promotion
      # action depends on eligibility of promotion for this order
      #
      # Returns success if at least one promotion was activated/deactivated
      #
      # @param order [Order]
      # @param promotions [Collection]
      # @param line_item [Spree::LineItem]
      # @return Right with :promotion_applied as value when at least one promotion was activated/deactivated
      # @return Left with :no_promotions_applied when no promotions were found
      #
      def call(input)
        order = input[:order]
        promotions = input[:promotions]
        line_item = input[:line_item]

        result = promotions.map do |promotion|
          payload = {
            order: order,
            promotion: promotion,
            line_item: line_item
          }

          if (line_item && promotion.eligible?(line_item)) || promotion.eligible?(order)
            activate.call(payload)
          else
            deactivate.call(payload)
          end
        end
        result.any?(&:success?) ? Right(:promotions_applied) : Left(:no_promotions_applied)
      end
    end
  end
end
