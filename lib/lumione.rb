require "lumione/version"
require "lumione/initializer"
require "lumione/bank"

module Lumione
  class Error < StandardError; end

  def self.convert_and_print(amount, from_currency, to_currency)
    Bank.convert_and_print amount, from_currency, to_currency
  end
end
