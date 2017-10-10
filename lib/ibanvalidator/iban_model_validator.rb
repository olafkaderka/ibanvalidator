module Ibanvalidator
  class IbanModelValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      iban = Ibanvalidator::IBAN.new(value)
      if !iban.valid?
      	iban.errors.each do |error|
        	record.errors.add attribute, error.to_sym
      	end
      end
    end
  end
end