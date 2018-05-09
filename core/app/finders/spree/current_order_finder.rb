module Spree
  class CurrentOrderFinder
    def initialize(params = {})
      @user = params[:user]
      @store = params[:store]
      @params = params.except(:user, :store).merge(store_id: @store.id)
    end

    def execute
      order = base_scope.find_by(@params)

      if order.nil? && @user.present?
        # gets last incomplete user order
        order = base_scope.where(store: @store, user: @user)
                          .order(created_at: :desc)
                          .first
      end

      order
    end

    private

    def base_scope
      Spree::Order.incomplete
                  .includes(line_items: [variant: [:images, :option_values, :product]])
    end
  end
end
