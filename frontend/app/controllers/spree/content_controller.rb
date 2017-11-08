module Spree
  class ContentController < Spree::StoreController
    # Don't serve local files or static assets
    before_action { render_404 if params[:path] =~ /(\.|\\)/ }
    after_action :fire_visited_path

    rescue_from ActionView::MissingTemplate, with: :render_404

    respond_to :html

    def test; end

    def cvv
      render layout: false
    end

    def fire_visited_path
      handle_promotion_transaction.call(order: current_order, path: params[:action])
    end

    private

    def handle_promotion_transaction
      container = Spree::PromotionContainer
      Spree::HandlePromotionTransaction.new(fetch: container['page.fetch'].new, activator: container['page.activator'].new)
    end
  end
end
