require "lumione/version"
require "lumione/initializer"
require "lumione/all"

module Lumione
  class Error < StandardError; end

  def self.main(amount, from_currency, to_currency)
    All.main amount, from_currency, to_currency
  end
end
