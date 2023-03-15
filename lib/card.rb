# frozen_string_literal: true

require "credit_card_validations"
require "byebug"

# Card Class
# Manages the Card logic including:
# Numbers, limit, balance, validation
class Card
  DEFAULT_BALANCE = 0

  attr_accessor :number, :limit, :balance, :valid

  def initialize(number: nil, limit: 0)
    @number = number
    @limit = new_limit(limit)
    @valid = valid?
    @balance = DEFAULT_BALANCE
  end

  # Checks if the Card's number is valid
  def valid?
    return false if number.blank?

    CreditCardValidations::Luhn.valid?(number)
  end

  # Addes balance to the Card
  def charge(charge_balance)
    if charge_balance.is_a?(Integer) && charge_balance.positive? && valid?
      new_balance = balance + charge_balance

      self.balance = new_balance if new_balance < limit
    end

    balance
  end

  # Substracts balanace from the Card
  def credit(credit_balance)
    valid_credit_balance = credit_balance.is_a?(Integer) && credit_balance.positive? && valid?

    self.balance -= credit_balance if valid_credit_balance

    balance
  end

  private

  def new_limit(new_limit)
    return new_limit if new_limit.is_a?(Integer) && new_limit.positive?

    0
  end
end
