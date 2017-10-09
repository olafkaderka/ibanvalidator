require 'active_support'
require 'active_support/core_ext'
require "ibanvalidator/version"
require 'ibanvalidator/conversion.rb'
require 'ibanvalidator/iban.rb'
require 'ibanvalidator/iban_rules.rb'

module Ibanvalidator
	mattr_accessor :default_rules
	mattr_accessor :rule_countries
	#falls noch nciht gesetzt zb in einem initializer.....
	Ibanvalidator.default_rules = (Ibanvalidator.default_rules || Ibanvalidator::IBANRules.defaults.rules)
	Ibanvalidator.rule_countries = (Ibanvalidator.rule_countries || Ibanvalidator.default_rules.keys)
end
