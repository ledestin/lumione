describe "lumione(1)" do
  it "converts NZD to USD" do
    conversion_output = convert "1 nzd usd"

    expect(conversion_output).to eq "$1.00 NZD ($0.66 USD)\n"
  end

  it "handles invalid amount" do
    conversion_output = convert "foo nzd usd"

    expect(conversion_output).to \
      include("foo: Invalid amount, please use a number")
  end

  private

  def convert(args_string)
    amount, original_currency, converted_to_currency = args_string.split
    `./bin/lumione #{amount} #{original_currency} #{converted_to_currency}`
  end
end
