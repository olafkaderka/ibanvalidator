# Ibanvalidator (under Construction)

Ibanvalidator ist eine Ruby/Rails Library zum überüfen von IBANs in > 60 Ländern. [Mehr Infos zur IBAN](https://de.wikipedia.org/wiki/IBAN)

Es basiert auf der gem [iban-tools](http://github.com/iulianu/iban-tools) von [Iulianu](http://github.com/iulianu) die dann vom Team
bei [AlphaSights](https://engineering.alphasights.com) weiterentwickelt wurde.

Wir wollen diese gem weiterpflegen und zusätzliche Funktionen integrieren.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ibanvalidator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ibanvalidator

## Usage

### quick validation
	require 'ibanvalidator'
	Ibanvalidator::IBAN.valid?("DE89370400440532013000") => true

### advanced
	require 'ibanvalidator'
	iban = Ibanvalidator::IBAN.new("DE89370 40044053201 3000")
	iban.valid? => true
	iban.code => "DE89370400440532013000"
	iban.bban => "370400440532013000"
	iban.country_code => "DE"
	iban.check_digits => "89"
	iban.prettify => "DE89 3704 0044 0532 0130 00"	
	iban.sepa_scheme? => true

	iban.to_local => {bank_code: '37040044', account_number: '532013000'} => standarmässig ohne führende Null
	
	iban = Ibanvalidator::IBAN.new("ES9121000418450200051332")
	iban.to_local => {:bank_code=>"2100", :branch_code=>"418", :check_digits=>"45", :account_number=>"2000513"} => ohne führende Nullen
	iban.to_local**(false)** => {:bank_code=>"2100", :branch_code=>"0418", :check_digits=>"45", :account_number=>"02000513"} => mit führende Nullen
	

### erroors
	iban.errors => liefert ein array mit den möglichen Fehlern
	* :iban_too_short, :iban_too_short, :iban_bad_chars => sind grundsätzliche Fehler
	* :iban_unknown_country_code, :iban_bad_length, :iban_bad_format, :iban_bad_check_digits => sind Regel-Fehler (also landesspezifisch) 


## Constants/Initits

	**Ibanvalidator.default_rules** => liefert alle IBAN Regeln

	**Ibanvalidator.rule_countries** => liefert ein Array mit allen Ländern für die eine Rule hinterlegt ist
	=> ["AD", "AE", "AL", "AT", "AZ", "BA", "BE" .... "VG"]

	**Ibanvalidator.sepa_countries** liefert alle Länder die im Sepa Raum liegen (grundlage für sepa_scheme?)

	
### ActiveRecord/Model Validator
Man kann auch den Model Validator einbinden. Die Fehlermeldungen sind übersetzt in deutsch und englisch siehe [/locales](https://github.com/olafkaderka/ibanvalidator/tree/master/lib/locales)

	validates :iban, iban_model: true
	
	locales:
	de:
  		errors:
    		messages:
      			iban_too_short: zu wenig Zeichen
      			iban_too_long: zu viel Zeichen
      			iban_bad_chars: ungültige Zeichen
      			iban_unknown_country_code: Land nicht unterstütz
      			iban_bad_length: falsche Länge
      			iban_bad_format: Formatfehler
      			iban_bad_check_digits: falsche Kontrollziffer




## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/olafkaderka/ibanvalidator. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


