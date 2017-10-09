require 'active_support'
require 'active_support/core_ext'
require "ibanvalidator/version"
require 'ibanvalidator/conversion.rb'
require 'ibanvalidator/iban.rb'
require 'ibanvalidator/iban_rules.rb'

module Ibanvalidator
	mattr_accessor :default_rules #all rules from yaml file 'rules'
	mattr_accessor :rule_countries ##country_keys from default_rules
	mattr_accessor :default_conversions ##all rules from yaml file 'conversion_rules'
	mattr_accessor :default_conversion_countries #country_keys from default_conversions


	#falls noch nciht gesetzt zb in einem initializer.....
	Ibanvalidator.default_rules = (Ibanvalidator.default_rules || Ibanvalidator::IBANRules.defaults.rules)
	Ibanvalidator.rule_countries = (Ibanvalidator.rule_countries || Ibanvalidator.default_rules.keys)

	#YAML.load_file(File.join(File.dirname(__FILE__), '/ibanvalidator', 'conversion_rules.yml'))
	if Ibanvalidator.default_conversions
	else
		Ibanvalidator.default_conversions = YAML.load_file(File.join(File.dirname(__FILE__), '/ibanvalidator', 'conversion_rules.yml'))
	end

	Ibanvalidator.rule_countries = (Ibanvalidator.rule_countries || Ibanvalidator.default_rules.keys)
	Ibanvalidator.default_conversion_countries = (Ibanvalidator.default_conversion_countries || Ibanvalidator.default_conversions.keys)

end
