module Spree

  # This is base class for all operations in Spree. Concept of operation will be described here
  #
  class BaseOperation
    include Dry::Transaction::Operation

    # This allows us to pass class to any transaction so we don't have to create instances for them manually
    def self.call(args)
      new.call(args)
    end
  end
end
