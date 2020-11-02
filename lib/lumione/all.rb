require "fileutils"
require "active_support/core_ext/numeric/time"
require 'action_view'

module Lumione
  class All
    include ActionView::Helpers::DateHelper

    DEFAULT_CACHE_DIR = File.join(Dir.home, ".cache", "lumione")
    CACHE_DIR = ENV["LUMIONE_CACHE_DIR"] || DEFAULT_CACHE_DIR
    CACHE_FILE = File.join(CACHE_DIR, "exchange_rates.xml")

    def self.main(amount, from_currency, to_currency)
      new.main amount, from_currency, to_currency
    end

    def main(amount, from_currency, to_currency)
      prepare_rates

      convert(amount, from_currency, to_currency)

      print_original_and_converted_money
    end

    def print_original_and_converted_money
      print format_conversion(@original_money, @converted_money)
      if bank.rates_updated_at < 2.days.ago
        print " (#{how_long_since_rates_were_updated(bank.rates_updated_at)})"
      end
      puts
    end

    def convert(amount, from_currency, to_currency)
      @original_money = Money.from_amount(amount, from_currency)
      @converted_money = @original_money.exchange_to(to_currency)
    end

    def prepare_rates
      create_cache_dir
      update_rates bank
    end

    def bank
      Money.default_bank
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
