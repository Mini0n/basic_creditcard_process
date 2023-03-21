# frozen_string_literal: true

require_relative "../main"
require "byebug"

RSpec.describe Main do
  subject(:main) { described_class.new }

  describe "#new" do
    it "creates a Main instance" do
      expect(subject).to be_a(Main)
      expect(subject).to have_attributes(filename: nil)
      expect(subject.processor).to be_a(Processor)
    end
  end

  describe "#read_instructions_from_file" do
    context "when a file is passed" do
      it "reads its content" do
        result = main.send(:read_instructions_from_file, "./spec/fixtures/original_test.txt")

        expect(result).to be_a(String)
      end
    end
  end

  describe "#read_instructions_from_stdin" do
    context "when data is passed through STDIN" do
      it "reads it" do
        input = File.open("./spec/fixtures/original_test.txt")
        input.read
        input.rewind
        $stdin = input

        result = main.send(:read_instructions_from_stdin)
        expect(result).to be_a(String)
      end
    end
  end
end
