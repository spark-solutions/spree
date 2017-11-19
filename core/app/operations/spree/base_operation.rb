module Spree

  # This is base class for all operations in Spree. Concept of operation will be described here
  #
  class BaseOperation
    include Dry::Transaction::Operation
  end
end
