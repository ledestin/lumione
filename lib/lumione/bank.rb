require "fileutils"
require "active_support/core_ext/numeric/time"
require 'action_view'

module Lumione
  class Bank
    include ActionView::Helpers::DateHelper

    DEFAULT_CACHE_DIR = File.join(Dir.home, ".cache", "lumione")
    CACHE_DIR = ENV["LUMIONE_CACHE_DIR"] || DEFAULT_CACHE_DIR
    CACHE_FILE = File.join(CACHE_DIR, "exchange_rates.xml")

    def self.convert_and_print(amount, from_currency, to_currency)
      new.convert_and_print amount, from_currency, to_currency
    end

    def convert_and_print(amount, from_currency, to_currency)
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
      update_and_load_rates
    end

    private

    def bank
      Money.default_bank
    end

    def create_cache_dir
      cache_dir = File.dirname CACHE_FILE
      FileUtils.mkdir_p cache_dir
    end

    def update_and_load_rates
      load_rates_from_cache
      return if up_to_date_rates?

      fetch_rates_and_save_to_cache
      load_rates_from_cache
    end

    def fetch_rates_and_save_to_cache
      bank.save_rates(CACHE_FILE)
    end

    def up_to_date_rates?
      !stale_rates?
    end

    def stale_rates?
      !bank.rates_updated_at || File.mtime(CACHE_FILE) < 1.day.ago
    end

    def load_rates_from_cache
      bank.update_rates(CACHE_FILE) if File.exists? CACHE_FILE
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
