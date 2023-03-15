# frozen_string_literal: true

# !/usr/bin/env ruby

require "ap"
require "byebug"

# Main Program Code
# This class interacts with the inputs, and the rest of the code
# to process the information and return the output.
class Main
  attr_accessor :filename

  def initialize
    @filename = nil
  end

  # Run the require program steps for it to read, process & output
  # the information
  def run_program
    # read_filename_from_stdin

    print_init_screen
    read_operations_filename

    processing_filename(filename)
  end

  # Assigns @filename wheter it was received as a param or through console
  def read_operations_filename
    self.filename ||= read_filename_from_param unless ARGV.empty?
    self.filename ||= read_filename_from_console if filename.nil?
  end

  # Prints Welcome Screen
  def print_init_screen
    puts "-." * 17
    puts ":: Basic Credit Card Processing ::"
    puts "-." * 17
    puts "\n"
  end


  private

  def processing_filename(filename)
    puts " > Processing #{filename}..."
  end

  def read_filename_from_console
    puts "> Please introduce an operations' input file (ex. inputs.txt):"
    gets.chomp
  end

  def read_filename_from_param
    ARGV.first
  end
end

# Run Main program

program = Main.new
program.run_program





# def read_filename_from_stdin
#   file_content = ""

#   if $stdin.tty?
#     ARGV.each do |file|
#       # puts "do something with this file: #{file}"
#       file_content << file
#     end
#   else
#     $stdin.each_line do |line|
#       # puts "do something with this line: #{line}"
#       file_content << line
#     end
#   end

#   ap file_content
#   byebug

# end
