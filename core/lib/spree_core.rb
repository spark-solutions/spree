require 'friendly_id/slug_rails5_patch'
require 'spree/core'
require "dry-container"
require "dry/transaction"
require "dry/transaction/operation"

require_relative '../app/operations/spree/promotions'
require_relative '../app/containers/spree/promotion_container'
require_relative '../app/transactions/spree/handle_promotion_transaction'
