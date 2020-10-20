describe "lumione(1)" do
  it "converts NZD to USD" do
    conversion_output = convert "1 nzd usd"

    expect(conversion_output).to eq "$1.00 NZD ($0.66 USD)\n"
  end

  private

  def convert(args_string)
    amount, original_currency, converted_to_currency = args_string.split
    `./bin/lumione #{amount} #{original_currency} #{converted_to_currency}`
  end
end
