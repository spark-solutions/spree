module Spree
  module ProductsHelper
    def cache_key_for_product(product = @product)
      cache_key_elements = common_product_cache_keys
      cache_key_elements += [
        product.cache_key_with_version,
        product.possible_promotions
      ]

      if product.respond_to?(:relations)
        cache_key_elements << "relations-#{product.relations.maximum(:updated_at)&.to_i}"
      end

      cache_key_elements.compact.join('/')
    end

    def default_variant(variants)
      variants_option_types_presenter(variants).default_variant || variants.find(&:is_master)
    end

    def used_variants_options(variants)
      variants_option_types_presenter(variants).options
    end

    # converts line breaks in product description into <p> tags (for html display purposes)
    def product_description(product)
      description = if Spree::Config[:show_raw_product_description]
                      product.description
                    else
                      product.description.to_s.gsub(/(.*?)\r?\n\r?\n/m, '<p>\1</p>')
                    end
      description.blank? ? Spree.t(:product_has_no_description) : description
    end

    def limit_descritpion(string)
      return string if string.length <= 450

      string.slice(0..449) + '...'
    end

    def available_status(product) # will return a human readable string
      return Spree.t(:discontinued)  if product.discontinued?
      return Spree.t(:deleted) if product.deleted?

      if product.available?
        Spree.t(:available)
      elsif product.available_on&.future?
        Spree.t(:pending_sale)
      else
        Spree.t(:no_available_date_set)
      end
    end

    def product_images(product, variants)
      variants = if product.variants_and_option_values(current_currency).any?
        variants.reject(&:is_master)
      else
        variants
      end

      variants.map(&:images).flatten
    end

    def product_variants_matrix
      Spree::VariantPresenter.new(@variants).call.to_json
    end

    def related_products
      @_related_products ||= @product
        .related_products
        .includes(
          master: [
            :default_price,
            images: { attachment_attachment: :blob }
          ]
        )
        .limit(Spree::Config[:products_per_page])
        .to_a
    end

    private

    def common_product_cache_keys
      [I18n.locale, current_currency] + price_options_cache_key
    end

    def price_options_cache_key
      current_price_options.sort.map(&:last).map do |value|
        value.try(:cache_key) || value
      end
    end

    def variants_option_types_presenter(variants)
      @_variants_option_types_presenter ||= begin
        option_types = Spree::Variants::OptionTypesFinder.new(variant_ids: variants.map(&:id)).execute

        Spree::Variants::OptionTypesPresenter.new(option_types)
      end
    end
  end
end
