require 'active_support'
require 'active_support/core_ext'
require 'yaml'
require "ibanvalidator/version"
require 'ibanvalidator/conversion.rb'
require 'ibanvalidator/iban.rb'
require 'ibanvalidator/iban_rules.rb'
require 'ibanvalidator/iban_rules.rb'


module Ibanvalidator
	mattr_accessor :default_rules
	mattr_accessor :rule_countries
	mattr_accessor :default_conversions
	mattr_accessor :default_conversion_countries


	#falls noch nciht gesetzt zb in einem initializer.....
	Ibanvalidator.default_rules = (Ibanvalidator.default_rules || Ibanvalidator::IBANRules.defaults.rules)
	Ibanvalidator.rule_countries = (Ibanvalidator.rule_countries || Ibanvalidator.default_rules.keys)

	#YAML.load_file(File.join(File.dirname(__FILE__), '/ibanvalidator', 'conversion_rules.yml'))
	if Ibanvalidator.default_conversions
	else
		Ibanvalidator.default_conversions = YAML.load_file(File.join(File.dirname(__FILE__), '/ibanvalidator', 'conversion_rules.yml'))
	end
	#Ibanvalidator.default_conversions = (Ibanvalidator.default_conversions ||  YAML.load_file(File.join(File.dirname(__FILE__), '/ibanvalidator', 'conversion_rules.yml'))  )
	Ibanvalidator.default_conversion_countries = (Ibanvalidator.default_conversion_countries || Ibanvalidator.default_conversions.keys)

end
