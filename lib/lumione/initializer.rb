require "eu_central_bank"

module Initializer
  def self.configure_money_gem
    I18n.config.available_locales = :en
    I18n.locale = :en
    Money.locale_backend = :i18n
    Money.rounding_mode= BigDecimal::ROUND_HALF_UP
    Money.default_bank = EuCentralBank.new
  end
end

Initializer.configure_money_gem
