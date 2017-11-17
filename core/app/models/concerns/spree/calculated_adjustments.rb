module Spree
  module CalculatedAdjustments
    extend ActiveSupport::Concern

    included do
      ActiveSupport::Deprecation.warn(<<-EOS, caller)
        Spree::CalculatedAdjustments will be removed in Spree 3.6
        This concern is useless and creates unneed coupling
      EOS
      has_one :calculator, class_name: 'Spree::Calculator', as: :calculable, inverse_of: :calculable, dependent: :destroy, autosave: true
      accepts_nested_attributes_for :calculator
      validates :calculator, presence: true
      delegate :compute, to: :calculator

      def self.calculators
        spree_calculators.send model_name_without_spree_namespace
      end

      def calculator_type
        calculator.class.to_s if calculator
      end

      def calculator_type=(calculator_type)
        klass = calculator_type.constantize if calculator_type
        self.calculator = klass.new if klass && !calculator.is_a?(klass)
      end

      private

      def self.model_name_without_spree_namespace
        to_s.tableize.tr('/', '_').sub('spree_', '')
      end

      def self.spree_calculators
        Rails.application.config.spree.calculators
      end
    end
  end
end
