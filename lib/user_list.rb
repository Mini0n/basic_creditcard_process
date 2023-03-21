# frozen_string_literal: true

require_relative "user"
require "byebug"

# User List Class
# A list of Users with finding & printing
class UserList
  attr_accessor :users, :cards

  def initialize
    @users = {}
    @cards = []
  end

  # Adds a user to the users Hash
  def add_user(user: nil)
    return if invalid_user?(user) || repeated_user_info?(user)

    cards << user&.card&.number
    users[user.name] = user
  end

  # removes a user from the users Hash
  def remove_user(user: nil)
    return if user.blank?

    users.delete(user.name)
  end

  # finds a user by name in the users Hash
  # the user name is the used as a hash key
  def find_user_by_name(name: nil)
    return if name.blank?

    users[name]
  end

  def length
    users.length
  end

  alias count length
  alias size length

  # It returns a String of the UserList as a list of:
  # user.name: user.balance\n
  def to_s
    users.values.map(&:to_s).sort.join("\n")
  end

  private

  def invalid_user?(user)
    user.blank? || user.name.blank? || user.card.blank?
  end

  def repeated_user_info?(user)
    users.key?(user.name) || cards.include?(user.card.number)
  end
end
