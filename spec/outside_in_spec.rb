describe "lumione(1)" do
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

  def convert(args)
    run_cmd_with_tty "./bin/lumione #{args}"
  end

  def run_cmd_with_tty(cmd)
    `LUMIONE_CACHE_DIR=./cache socat -ly - EXEC:'#{cmd}',pty,ctty,stderr`.rstrip
  end
end
