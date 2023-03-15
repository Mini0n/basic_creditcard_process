# frozen_string_literal: true

require "credit_card_validations"
require "byebug"

# Card Class
# Manages the Card logic including:
# Numbers, limit, balance, validation
class Card
  attr_accessor :number, :limit, :balance, :valid

  def initialize(number: nil, limit: 0)
    @number = number
    @limit = limit
    @balance = 0
    @valid = valid?
  end

  def valid?
    return false if number.blank?
    CreditCardValidations::Luhn.valid?(number)
  end

  def charge(added_balance)
    if added_balance.is_a?(Integer) && added_balance.positive? && valid?
      new_balance = self.balance + added_balance

      self.balance = new_balance if new_balance < limit
    end

    balance
  end

  def credit(substracted_balance)
    if substracted_balance.is_a?(Integer) && substracted_balance.positive? && valid?
      self.balance -= substracted_balance
    end

    balance
  end

end
