#see https://de.wikipedia.org/wiki/IBAN
module Ibanvalidator
  class IBAN

    #attr_accessor :code, :bank, :country, :location, :branch

    def initialize( code )
      @code = IBAN.canonicalize_code(code)
    end

    # The code in canonical form,
    # suitable for storing in a database
    # or sending over the wire
    def code
      @code
    end

     def country_code
      @code[0..1]
    end

    def check_digits
      @code[2..3]
    end

    def bban
      @code[4..-1]
    end


    def self.valid?( code, rules = nil )
      new(code).validation_errors(rules).empty?
    end

    def self.canonicalize_code( code )
      code.to_s.strip.gsub(/\s+/, '').upcase
    end

    # Load and cache the default rules from rules.yml
    def self.default_rules
      @default_rules ||= IBANRules.defaults
    end

    def self.from_local(country_code, data)
      Conversion.local2iban country_code, data
    end


    def to_local
      Conversion.iban2local country_code, bban
    end

    def to_s
      "#<#{self.class}: #{prettify}>"
    end

    # The IBAN code in a human-readable format
    def prettify
      @code.gsub(/(.{4})/, '\1 ').strip
    end

    def validation_errors( rules = nil )
      errors = []
      return [:too_short] if @code.size < 5
      return [:too_long] if @code.size > 34
      return [:bad_chars] unless @code =~ /^[A-Z0-9]+$/
      errors += validation_errors_against_rules( rules || IBAN.default_rules )
      errors << :bad_check_digits unless valid_check_digits?
      errors
    end


    def validation_errors_against_rules( rules )
      errors = []
      return [:unknown_country_code] if rules[country_code].nil?
      errors << :bad_length if rules[country_code]["length"] != @code.size
      errors << :bad_format unless bban =~ rules[country_code]["bban_pattern"]
      errors
    end


    ########### Pruefdsummen siehe https://de.wikipedia.org/wiki/IBAN#Validierung_der_Pr.C3.BCfsum
    #Nun wird der Rest berechnet, der sich beim ganzzahligen Teilen der Zahl durch 97 ergibt (Modulo 97).
    def valid_check_digits?
      ##Das Ergebnis muss 1 sein, ansonsten ist die IBAN falsch.
      numerify.to_i % 97 == 1
    end

    def numerify
      #Diese setzt sich aus 
      #BBAN (in Deutschland z. B. 18 Stellen) + Länderkürzel kodiert + Prüfsumme zusammen. 
      #Dabei werden die beiden Buchstaben des Länderkürzels sowie weitere etwa in der Kontonummer enthaltene Buchstaben durch ihre Position im lateinischen Alphabet + 9 ersetzt 
      #(A = 10, B = 11, …, Z = 35).
      numerified = ""
      (@code[4..-1] + @code[0..3]).each_byte do |byte|
        numerified += case byte
        # 0..9
        when 48..57 then byte.chr
        # 'A'..'Z'
        when 65..90 then (byte - 55).to_s # 55 = 'A'.ord + 10
        else
          raise RuntimeError.new("Unexpected byte '#{byte}' in IBAN code '#{prettify}'")
        end
      end
      numerified
    end

    ######################## Pruefsummen

  end
end
