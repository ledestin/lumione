require "fileutils"
require "active_support/core_ext/numeric/time"
require 'action_view'
require "eu_central_bank"

module Lumione
  class All
    include ActionView::Helpers::DateHelper

    CACHE_FILE = File.join(Dir.home, ".cache", self.name.downcase,
                           "exchange_rates.xml")

    def self.main(amount, from_currency, to_currency)
      new.main amount, from_currency, to_currency
    end

    def main(amount, from_currency, to_currency)
      configure_money_gem

      amount = Float(amount)
      create_cache_dir
      update_rates bank

      original_money = Money.from_amount(amount, from_currency)
      converted_money = original_money.exchange_to(to_currency)

      print format_conversion(original_money, converted_money)
      if bank.rates_updated_at < 2.days.ago
        print " (#{how_long_since_rates_were_updated(bank.rates_updated_at)})"
      end
      puts
    end

    def bank
      @bank ||= EuCentralBank.new
    end

    def configure_money_gem
      I18n.config.available_locales = :en
      I18n.locale = :en
      Money.locale_backend = :i18n
      Money.rounding_mode= BigDecimal::ROUND_HALF_UP
      Money.default_bank = bank
    end

    def create_cache_dir
      cache_dir = File.dirname CACHE_FILE
      FileUtils.mkdir_p cache_dir
    end

    def update_rates(bank)
      bank.update_rates(CACHE_FILE) if File.exists? CACHE_FILE

      if !bank.rates_updated_at || File.mtime(CACHE_FILE) < 1.day.ago
        bank.save_rates(CACHE_FILE)
        bank.update_rates(CACHE_FILE)
      end
    end

    def how_long_since_rates_were_updated(rates_updated_at)
      "rates updated #{distance_of_time_in_words_to_now rates_updated_at} ago"
    end

    def format_conversion(original_money, converted_money)
      formatted_original_money = original_money.format(with_currency: true)
      formatted_converted_money = converted_money.format(with_currency: true)
      "#{formatted_original_money} (#{formatted_converted_money})"
    end
  end
end
