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
	iban.code => "DE89370400440532013000"
	iban.bban => "370400440532013000"
	iban.country_code => "DE"
	iban.to_local => {bank_code: '37040044', account_number: '532013000'}
	iban.check_digits => "89"
	iban.prettify => "DE89 3704 0044 0532 0130 00"	
	iban.sepa_scheme? => true



	Ibanvalidator.default_rules, liefert alle IBAN Regeln
	**Ibanvalidator.rule_countries**, liefert ein Array mit allen Ländern für die eine Rule hinterlegt ist
	=> ["AD", "AE", "AL", "AT", "AZ", "BA", "BE", "BG", "BH", "BR", "CH", "CY", "CZ", "DE", "DK", "DO", "EE", "ES", "FI", "FO", "FR", "GB", "GE", "GI", "GL", "GR", "HR", "HU", "IE", "IL", "IS", "IT", "JO", "KW", "KZ", "LB", "LI", "LT", "LU", "LV", "MC", "MD", "ME", "MK", "MR", "MT", "MU", "NL", "NO", "PK", "PL", "PT", "PS", "QA", "RO", "RS", "SA", "SE", "SI", "SK", "SM", "TN", "TR", "UA", "VG"]

	**Ibanvalidator.sepa_countries** liefert alle Länder die im Sepa Raum liegen
	





## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/olafkaderka/ibanvalidator. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


