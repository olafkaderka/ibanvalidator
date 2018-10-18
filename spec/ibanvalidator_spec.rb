require "spec_helper"
require 'ibanvalidator'
require 'ibanvalidator/iban'
require 'ibanvalidator/iban_rules'

RSpec.describe Ibanvalidator do
  
  it "has a version number" do
    expect(Ibanvalidator::VERSION).not_to be nil
  end



  it "rules check" do
     expect(Ibanvalidator.rule_countries).not_to be nil
     expect(Ibanvalidator.default_conversion_countries).not_to be nil
     diff = Ibanvalidator.rule_countries - Ibanvalidator.default_conversion_countries
     #alle laender haben auch eine conversion rule
     expect(diff).to eq([])
  end


  class Model
      include ActiveModel::Validations
      attr_accessor :iban
      validates :iban, iban_model: true
      def initialize(iban)
        @iban = iban
      end
  end
  
  it 'ABZD is toot_short' do
      I18n.locale = :en
      model = Model.new 'ABZD'
      model.valid?
      expect(model.errors.count).to eq(1)
      expect(model.errors.messages).to eq({:iban=>["too_short"]})

      I18n.locale = :de
      model = Model.new 'ABZE'
      model.valid?
      expect(model.errors.messages).to eq({:iban=>["zu wenig Zeichen"]})
  end


  it "IBAN too short" do 
    iv = Ibanvalidator::IBAN.new("ABZD")
    expect(iv.validation_errors).to eq([:iban_too_short])
    expect !iv.valid?
  end

  it "IBAN too long" do 
    iv = Ibanvalidator::IBAN.new("ABZDKFSASIFGASBKISFKASBFIHASVFISFGIASBKABSFKASFKACKJASHFS")
    expect(iv.validation_errors).to eq([:iban_too_long])
    expect !iv.valid?
  end

  it "IBAN bad_chars" do 
    iv = Ibanvalidator::IBAN.new("ABZDKFSASIFÄÄÄÄÄ")
    expect(iv.validation_errors).to eq([:iban_bad_chars])
    expect !iv.valid?
  end


  it "Test Deuschland aus Readme" do
        iban = Ibanvalidator::IBAN.new("DE89370 40044053201 3000")
        expect(iban.code).to eq("DE89370400440532013000")
        expect(iban.country_code).to eq("DE")
        expect(iban.bban).to eq("370400440532013000")
        expect(iban.to_local).to eq({bank_code: '37040044', account_number: '532013000'})
        expect(iban.check_digits).to eq("89")
        expect(iban.prettify).to eq("DE89 3704 0044 0532 0130 00")
        expect iban.sepa_scheme?
        expect iban.valid?

        expect Ibanvalidator::IBAN.new("DE89370 40044053201 3000").valid?
  end

  it "Test Spanien mit führenden nullen, ignore_zero => false" do
        iban = Ibanvalidator::IBAN.new("ES9121000418450200051332")
        expect(iban.to_local).to eq({:bank_code=>"2100", :branch_code=>"418", :check_digits=>"45", :account_number=>"2000513"})
        expect(iban.to_local(true)).to eq({:bank_code=>"2100", :branch_code=>"0418", :check_digits=>"45", :account_number=>"02000513"})
        expect(iban.locale_bank_code).to eq("21000418")

  end

  it "DE23 2004 1133 0008 3033 07" do
    iban = Ibanvalidator::IBAN.new("DE23 2004 1133 0008 3033 07")
    expect(iban.to_local).to eq({:bank_code=>"20041133", :account_number=>"8303307"})
    expect iban.valid?
    
    iban = Ibanvalidator::IBAN.new("DE23 2004 1133 0830 3307 00")
    expect(iban.to_local).to eq({:bank_code=>"20041133", :account_number=>"830330700"})
    expect iban.valid?
    
    
    #https://de.wikipedia.org/wiki/IBAN#Online-Validierung
    #Ein Nachteil dieses Dienstes ist, dass auch die IBAN DE23 2004 1133 0008 3033 07 
    #fälschlicherweise als korrekt erkannt wird. 
    #Das Konto 8303307 bei der Bank mit der BLZ 20041133 hat in Wirklichkeit noch eine zweistellige Unterkontonummer, 
    #die nur in der IBAN sichtbar wird. 
    #In diesem Fall lautet die IBAN also DE65 2004 1133 0830 3307 00. 
    #Wegen solcher Tücken bieten einige Anbieter von kommerziellen Online-IBAN-Validierungen und -Berechnungen Korrektheitsgarantien an.
  end



  IBAN_FOR_TEST = {
      'AD1200012030200359100100' => {bank_code: '1', branch_code: '2030', account_number: '200359100100'},
      'AE070331234567890123456' => {bank_code: '33', account_number: '1234567890123456'},
      'AL47212110090000000235698741' => {bank_code: '212', branch_code: '1100', check_digit: '9', account_number: '235698741'},
      'AT611904300234573201' => {bank_code: '19043', account_number: '234573201'},
      'AZ21NABZ00000000137010001944' => {bank_code: 'NABZ', account_number: '137010001944'},
      'BA391290079401028494' => {bank_code: '129', branch_code: '7', account_number: '94010284', check_digits: '94'},
      'BE68539007547034' => {bank_code: '539', account_number: '75470', check_digits: '34'},
      'BG80BNBG96611020345678' => {bank_code: 'BNBG', branch_code: '9661', account_type: '10', account_number: '20345678'},
      'BH67BMAG00001299123456' => {bank_code: 'BMAG', account_number: '1299123456'},
      'CH9300762011623852957' => {bank_code: '762', account_number: '11623852957'},
      'CY17002001280000001200527600' => {bank_code: '2', branch_code: '128', account_number: '1200527600'},
      'CZ6508000000192000145399' => {bank_code: '800', account_prefix: '19', account_number: '2000145399'},
      'DE89370400440532013000' => {bank_code: '37040044', account_number: '532013000'},
      'DK5000400440116243' => {bank_code: '40', account_number: '440116243'},
      'DO28BAGR00000001212453611324' => {bank_code: 'BAGR', account_number: '1212453611324'},
      'EE382200221020145685' => {bank_code: '22', branch_code: '0', account_number: '2210201456', check_digits: '85'},
      'ES9121000418450200051332' => {:bank_code=>"2100", :branch_code=>"418", :check_digits=>"45", :account_number=>"2000513"},
      'FI2112345600000785' => {bank_code: '123456', account_number: '78', check_digit: '5'},
      'FO7630004440960235' => {bank_code: '3000', account_number: '444096023', check_digit: '5'},
      'FR1420041010050500013M02606' => {bank_code: '20041', branch_code: '1005', account_number: '500013M026', check_digits: '6'},
      'GB29NWBK60161331926819' => {bank_code: 'NWBK', branch_code: '601613', account_number: '31926819'},
      'GE29NB0000000101904917' => {bank_code: 'NB', account_number: '101904917'},
      'GI75NWBK000000007099453' => {bank_code: 'NWBK',account_number: '7099453'},
      'GL4330003330229543' => {bank_code: '3000', account_number: '3330229543'},
      'GR1601101250000000012300695' => {bank_code: '11', branch_code: '125', account_number: '12300695'},
      'HR1210010051863000160' => {bank_code: '1001005', account_number: '1863000160'},
      'HU42117730161111101800000000' => {bank_code: '117', branch_code: '7301', account_prefix: '6', account_number: '111110180000000', check_digit: '0'},
      'IE29AIBK93115212345678' => {bank_code: 'AIBK', branch_code: '931152', account_number: '12345678'},
      'IL620108000000099999999' => {bank_code: '10', branch_code: '800', account_number: '99999999'},
      'IS140159260076545510730339' => {bank_code: '159', branch_code: '26', account_number: '7654', kennitala: '5510730339'},
      'IT60X0542811101000000123456' => {check_char: 'X', bank_code: '5428', branch_code: '11101', account_number: '123456'},
      'JO94CBJO0010000000000131000302' => {bank_code: 'CBJO', branch_code: '10', zeros: '0', account_number: '131000302'},
      'KW81CBKU0000000000001234560101' => {bank_code: 'CBKU', account_number: '1234560101'},
      'KZ86125KZT5004100100' => {bank_code: '125', account_number: 'KZT5004100100'},
      'LB62099900000001001901229114' => {bank_code: '999', account_number: '1001901229114'},
      'LI21088100002324013AA' => {bank_code: '8810', account_number: '2324013AA'},
      'LT121000011101001000' => {bank_code: '10000', account_number: '11101001000'},
      'LU280019400644750000' => {bank_code: '1', account_number: '9400644750000'},
      'LV80BANK0000435195001' => {bank_code: 'BANK', account_number: '435195001'},
      'MC1112739000700011111000H79' => {bank_code: '12739',branch_code: '70', account_number: '11111000H', check_digits: '79'},
      'MD24AG000225100013104168' => {bank_code: 'AG', account_number: '225100013104168'},
      'ME25505000012345678951' => {bank_code: '505', account_number: '123456789', check_digits: '51'},
      'MK07300000000042425' => {bank_code: '300', account_number: '424', check_digits: '25'},
      'MR1300020001010000123456753' => {bank_code: '20', branch_code: '101', account_number: '1234567', check_digits: '53'},
      'MT84MALT011000012345MTLCAST001S' => {bank_code: 'MALT', branch_code: '1100', account_number: '12345MTLCAST001S'},
      'MU17BOMM0101101030300200000MUR' => {bank_code: 'BOMM01', branch_code: '1', account_number: '101030300200000MUR'},
      'NL91ABNA0417164300' => {bank_code: 'ABNA', account_number: '417164300'},
      'NO9386011117947' => {bank_code: '8601', account_number: '111794', check_digit: '7'},
      'PK36SCBL0000001123456702' => {bank_code: 'SCBL', account_number: '1123456702'},
      'PL27114020040000300201355387' => {bank_code: '114', branch_code: '200', check_digit: '4', account_number: '300201355387'},
      'PS92PALS000000000400123456702' => {bank_code: 'PALS', account_number: '400123456702'},
      'PT50000201231234567890154' => {bank_code: '2', branch_code: '123', account_number: '12345678901', check_digits: '54'},
      'QA58DOHB00001234567890ABCDEFG' => {bank_code: 'DOHB', account_number: '1234567890ABCDEFG'},
      'RO49AAAA1B31007593840000' => {bank_code: 'AAAA', account_number: '1B31007593840000'},
      'RS35260005601001611379' => {bank_code: '260', account_number: '56010016113', check_digits: '79'},
      'SA0380000000608010167519' => {bank_code: '80', account_number: '608010167519'},
      'SE3550000000054910000003' => {bank_code: '500', account_number: '5491000000', check_digit: '3'},
      'SI56191000000123438' => {bank_code: '19', branch_code: '100', account_number: '1234', check_digits: '38'},
      'SK3112000000198742637541' => {bank_code: '1200', account_prefix: '19', account_number: '8742637541'},
      'SM86U0322509800000000270100' => {check_char: 'U', bank_code: '3225', branch_code: '9800', account_number: '270100'},
      'TN5914207207100707129648' => {bank_code: '14', branch_code: '207', account_number: '207100707129648'},
      'TR330006100519786457841326' => {bank_code: '61', reserved: '0', account_number: '519786457841326'},
      'VG96VPVG0000012345678901' => {bank_code: 'VPVG', account_number: '12345678901'},
      'UA213996220000026007233566001' => {bank_code: '399622', account_number: '26007233566001'},
      'BR9700360305000010009795493P1' => {bank_code: '360305', branch_code: '1', account_number: '9795493'},
      'GT82TRAJ01020000001210029690' => {:bank_code=>"TRAJ", :currency=>"1", :account_type=>"2", :account_number=>"1210029690"},
      'XK051212012345678906' => {:bank_code=>"1212", :account_number=>"12345678906"},
    }

      IBAN_FOR_TEST.each do |iban,local|
           it "returns valid local data for #{iban}" do
            iv = Ibanvalidator::IBAN.new(iban)
            expect(iv.to_local).to eq(local)
            expect iv.valid?
           end
      end


end
