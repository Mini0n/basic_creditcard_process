# frozen_string_literal: true

# !/usr/bin/env ruby

require "ap"
require "byebug"
require_relative "./lib/processor"

# Main Program Code
# This class interacts with the inputs, and the rest of the code
# to process the information and return the output.
class Main
  attr_accessor :filename, :processor

  def initialize
    @filename = nil
    @processor = Processor.new
  end

  # Run the require program steps for it to read, process & output
  # the information
  def run_program
    input_instructions = read_instructions_from_stdin

    print_init_screen

    if input_instructions.blank?
      puts "Reading instructions from file..."
      read_instructions_filename
      input_instructions = read_instructions_from_file(filename)
    end

    process_instructions(input_instructions)
  rescue StandardError => e
    print_error_screen(e)
  end

  # Prints Welcome Screen
  def print_init_screen
    puts "-." * 17
    puts ":: Basic Credit Card Processing ::"
    puts "-." * 17
    puts "\n"
  end

  private

  def process_instructions(instructions)
    puts "Processing instructions..."
    input_instructions = instructions.split("\n")

    input_instructions.each do |instruction|
      processor.process_instruction(instruction: instruction)
    end

    puts "Done\n\n"
    puts processor.user_list.to_s
  end

  def read_instructions_filename
    self.filename ||= read_filename_from_param unless ARGV.empty?
    self.filename ||= read_filename_from_console if filename.nil?
  end

  def read_instructions_from_file(filename)
    file = File.open(filename)
    file_data = file.read
    return unless file_data.is_a?(String)

    file_data
  end

  def read_instructions_from_stdin
    return if $stdin.tty? # return if $stdin is a file

    stdin_input = $stdin.read
    return unless stdin_input.is_a?(String)

    stdin_input
  end

  def read_filename_from_console
    puts "Please introduce an operations input file (ex. inputs.txt):"
    gets.chomp
  end

  def read_filename_from_param
    ARGV.first
  end

  def print_error_screen(e)
    puts "_" * 34
    puts "Whoops! An error has ocurred."
    puts "Please verify the input given.\n\n"
    puts e.message
    puts "_" * 34
  end
end

# Run Main program
program = Main.new
program.run_program
