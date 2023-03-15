# frozen_string_literal: true

require "credit_card_validations"
require "byebug"

# Card Class
# Manages the Card logic including:
# Numbers, limit, balance, validation
class Card
  attr_accessor :number, :limit, :balance, :valid

  def initialize(number: nil, limit: 0, balance: 0, valid: false)
    @number = number
    @limit = limit
    @balance = balance
    @valid = valid?
  end

  def valid?
    CreditCardValidations::Luhn.valid?(number)
  end

end
