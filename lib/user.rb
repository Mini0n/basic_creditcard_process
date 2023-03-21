# frozen_string_literal: true

require_relative "card"
require "byebug"

# User Class
# Manages the User logic including:
# Names, Card operations & validation
class User
  attr_accessor :name, :card

  def initialize(name: nil, card: nil)
    @name = name || "<unamed>[#{object_id}]"
    @card = card
  end

  # Checks if the User has a valid Card
  def valid?
    self&.card&.valid? || false
  end

  # Returns the User's Card balance
  def balance
    return "error" unless valid?

    self&.card&.balance
  end

  # Charges balance to the User's Card
  def charge(charge_balance)
    self&.card&.charge(charge_balance)
  end

  # Takes balance from the User's Card
  def credit(credit_balance)
    self&.card&.credit(credit_balance)
  end

  # Prints the user & balance(or "error")
  def to_s
    "#{name}: #{valid? ? '$' : ''}#{balance}"
  end
end
