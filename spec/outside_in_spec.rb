describe "lumione(1)" do
  before :all do
    ensure_we_use_fixture_rates
  end

  it "converts NZD to USD" do
    conversion_output = convert "1 nzd usd"

    expect(conversion_output).to eq "$1.00 NZD ($0.66 USD)"
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
    FileUtils.cp %w[./spec/fixtures/exchange_rates.xml], "./tmp/"
    `ruby -ne '
      today = Time.now.strftime("%Y-%m-%d");
      puts $_.sub("2020-09-29", today)
      ' < tmp/exchange_rates.xml -i tmp/exchange_rates.xml`
    @env_var_to_pass_fixture_rates = "LUMIONE_CACHE_DIR=./tmp"
  end

  def convert(args)
    run_cmd_with_tty "./bin/lumione #{args}"
  end

  def run_cmd_with_tty(cmd)
    `#{@env_var_to_pass_fixture_rates} socat -ly - EXEC:'#{cmd}',pty,ctty,stderr`.rstrip
  end
end
