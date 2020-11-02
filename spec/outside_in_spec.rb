require "active_support/core_ext/integer"

describe "lumione(1)" do
  let(:today) { Time.now }

  before do
    ensure_we_use_fixture_rates
  end

  it "converts NZD to USD" do
    conversion_output = convert "1 nzd usd"

    expect(conversion_output).to eq "$1.00 NZD ($0.66 USD)"
  end

  context "1 month ago" do
    let(:today) { 1.month.ago }

    it "reports, when rates are outdated" do
      conversion_output = convert "1 nzd usd"

      expect(conversion_output).to eq \
        "$1.00 NZD ($0.66 USD) (rates updated about 1 month ago)"
    end
  end

  it "handles invalid amount" do
    conversion_output = convert "foo nzd usd"

    expect(conversion_output).to eq "foo: Invalid amount, please use a number"
  end

  it "handles invalid currency" do
    conversion_output = convert "1 foo usd"

    expect(conversion_output).to eq "Unknown currency 'foo'"
  end

  private

  def ensure_we_use_fixture_rates
    FileUtils.mkdir_p "./tmp"
    set_rates_date today
    @env_var_to_pass_fixture_rates = "LUMIONE_CACHE_DIR=./tmp"
  end

  def set_rates_date(date)
    FileUtils.cp %w[./spec/fixtures/exchange_rates.xml], "./tmp/"

    date = date.strftime("%Y-%m-%d");
    `ruby -ne '
      today = "#{date}"
      puts $_.sub("2020-09-29", today)
      ' < tmp/exchange_rates.xml -i tmp/exchange_rates.xml`
  end

  def convert(args)
    run_cmd_with_tty "./bin/lumione #{args}"
  end

  def run_cmd_with_tty(cmd)
    `#{@env_var_to_pass_fixture_rates} socat -ly - EXEC:'#{cmd}',pty,ctty,stderr`.rstrip
  end
end
