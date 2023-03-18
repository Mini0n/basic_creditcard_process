# frozen_string_literal: true

require "user_list"
require "byebug"

# Procesor Class
# Handles instructions decoding & execution
class Processor
  attr_accessor :user_list

  NAME_REGEX = / [a-zA-Z]+/.freeze # only letters (lower & upper)
  AMOUNT_REGEX = / \$[0-9]+/.freeze # only numbers starting with '$'
  CARD_NUMBER_REGEX = / [0-9]{1,19}/.freeze # only digits (from 1 up to 19)


  def initialize
    @user_list = UserList.new
  end

  # Parse an instruction an line and
  # return a hash with the instruction type & parameters
  def parse_instruction(instruction: nil)
    return unless valid_instruction?(instruction)

    instruction_data = instruction.split(" ")

    case instruction_type(instruction)
    when :add
      {
        instruction: :add,
        user_name: instruction_data[1],
        card_number: instruction_data[2],
        card_limit: instruction_data[3]
      }
    when :charge
      {
        instruction: :charge,
        user_name: instruction_data[1],
        charge_amount: instruction_data[2]
      }
    when :credit
      {
        instruction: :credit,
        user_name: instruction_data[1],
        credit_amount: instruction_data[2]
      }
    end
  end

  # Call the required method to execute the instruction hash
  def process_instruction_hash(instruction_hash: nil)
    return unless instruction_hash.is_a?(Hash) && instruction_hash.present?

    case instruction_hash&.[](:instruction)
    when :add
      process_add(instruction_hash)
    when :charge
      process_charge(instruction_hash)
    when :credit
      process_credit(instruction_hash)
    end
  end

  # Parses an String instruction and then processes it
  def process_instruction(instruction: nil)
    instruction_hash = parse_instruction(instruction: instruction)
    return unless instruction_hash

    process_instruction_hash(instruction_hash: instruction_hash)
  end

  private

  def process_add(instruction_data)
    limit = parse_amount(instruction_data[:card_limit])
    add_user_card = Card.new(number: instruction_data[:card_number], limit: limit)
    add_user = User.new(name: instruction_data[:user_name], card: add_user_card)

    user_list.add_user(user: add_user)
  end

  def process_charge(instruction_data)
    charge_amount = parse_amount(instruction_data[:charge_amount])
    charged_user = user_list.find_user_by_name(name: instruction_data[:user_name])
    charged_user.charge(charge_amount)
  end

  def process_credit(instruction_data)
    credit_amount = parse_amount(instruction_data[:credit_amount])
    credited_user = user_list.find_user_by_name(name: instruction_data[:user_name])
    credited_user.credit(credit_amount)
  end

  def parse_amount(amount)
    return 0 unless amount.is_a?(String) && (amount =~ /^\$[0-9]+$/) == 0

    amount[1..].to_s.to_i
  end

  def instruction_type(instruction)
    return :add if (instruction =~ add_regex) == 0
    return :charge if (instruction =~ charge_regex) == 0
    return :credit if (instruction =~ credit_regex) == 0
  end

  def valid_instruction?(instruction)
    return false unless instruction.is_a?(String)

    (instruction =~ instruction_regex) == 0
  end

  def instruction_regex
    @instruction_regex ||= Regexp.new("#{add_regex}|#{charge_regex}|#{credit_regex}")
  end

  def add_regex
    @add_regex ||= Regexp.new("#{/add/i}#{NAME_REGEX}#{CARD_NUMBER_REGEX}#{AMOUNT_REGEX}")
  end

  def charge_regex
    @charge_regex ||= Regexp.new("#{/charge/i}#{NAME_REGEX}#{AMOUNT_REGEX}")
  end

  def credit_regex
    @credit_regex ||= Regexp.new("#{/credit/i}#{NAME_REGEX}#{AMOUNT_REGEX}")
  end
end
