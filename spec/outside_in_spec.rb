describe "lumione(1)" do
  it "converts NZD to USD" do
    conversion_output = convert "1 nzd usd"

    expect(conversion_output).to eq "$1.00 NZD ($0.66 USD)"
  end

  it "handles invalid amount" do
    conversion_output = convert "foo nzd usd"

    expect(conversion_output).to \
      include("foo: Invalid amount, please use a number")
  end

  private

  def convert(args_string)
    amount, original_currency, converted_to_currency = args_string.split
    run_cmd_with_tty "./bin/lumione #{amount} #{original_currency} #{converted_to_currency}"
  end

  def run_cmd_with_tty(cmd)
    `socat -ly - EXEC:'#{cmd}',pty,ctty 2>&1`.rstrip
  end
end
