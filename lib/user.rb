# frozen_string_literal: true

require "card.rb"
require "byebug"

# User Class
# Manages the User logic including:
# Names, Card numbers, Card limit, Card balance
class User
  attr_accessor :name, :card

  def initialize(name: nil, card: nil)
    @name = name
    @card = card
  end

  # Checks if the User has a valid Card
  def valid?
    self&.card&.valid?
  end

  # Returns the User's Card balance
  def balance
    self&.card&.balanace
  end

  # Charges balance to the User's Card
  def charge(charge_balance)
    self&.card&.charge(charge_balance)
  end

  # Takes balance from the User's Card
  def credit(credit_balance)
    self&.card&.credit(credit_balance)
  end

end
