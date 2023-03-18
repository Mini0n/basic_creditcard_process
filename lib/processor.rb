# frozen_string_literal: true

require "user_list"
require "byebug"

# Procesor Class
# Handles instructions decoding & execution
class Processor
  PARAM_SEPARATOR = " "
  OPERATIONS = %w[add charge credit].freeze

  NAME_REGEX = / [a-zA-Z]+/.freeze # only letters (lower & upper)
  AMOUNT_REGEX = / \$[0-9]+/.freeze # only numbers starting with '$'
  CARD_NUMBER_REGEX = / [0-9]{1,19}/.freeze # only digits (from 1 up to 19)
  OPERATIONS_REGEX = /#{OPERATIONS.join("|")}/i.freeze # only defined operations (lower & uper)


  # Parse an instruction line
  def parse_instruction(instruction: nil)
    return unless instruction.is_a?(String) || instruction.blank?

    instruction_parts = instruction.split(PARAM_SEPARATOR)

    return if instruction_parts.length != 3

    instruction_parts
  end



  private

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
