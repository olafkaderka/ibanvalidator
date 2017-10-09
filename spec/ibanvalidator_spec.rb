require "spec_helper"
require 'ibanvalidator'
require 'ibanvalidator/iban'

RSpec.describe Ibanvalidator do
  it "has a version number" do
    expect(Ibanvalidator::VERSION).not_to be nil
  end

  it "IBAN too short" do 
    iv = Ibanvalidator::IBAN.new("ABZD")
    expect(iv.validation_errors).to eq([:too_short])
  end

  it "IBAN too long" do 
    iv = Ibanvalidator::IBAN.new("ABZDKFSASIFGASBKISFKASBFIHASVFISFGIASBKABSFKASFKACKJASHFS")
    expect(iv.validation_errors).to eq([:too_long])
  end

end
