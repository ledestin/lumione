describe "lumione(1)" do
  it "converts NZD to USD" do
    conversion_output = `./bin/lumione 1 nzd usd`

    expect(conversion_output).to eq "$1.00 NZD ($0.66 USD)\n"
  end
end
