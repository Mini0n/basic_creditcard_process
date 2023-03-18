# frozen_string_literal: true

require "processor"
require "byebug"

RSpec.describe Processor do
  describe "constants" do
    it "has PARAM_SEPARATOR" do
      expect(described_class::PARAM_SEPARATOR).not_to be_nil
    end

    it "has OPERATIONS" do
      expect(described_class::OPERATIONS).to be_a(Array)
    end

    it "has Regex constants" do
      expect(described_class::NAME_REGEX).to be_a(Regexp)
      expect(described_class::AMOUNT_REGEX).to be_a(Regexp)
      expect(described_class::CARD_NUMBER_REGEX).to be_a(Regexp)
      expect(described_class::OPERATIONS_REGEX).to be_a(Regexp)
    end
  end

  describe "#add_regex" do
    it "returns add instruction parsing Regexp" do
      subject = described_class.new
      result_regex = subject.send(:add_regex)

      expect(result_regex).to be_a(Regexp)
      expect(result_regex.to_s).to include(/add/i.to_s)
      expect(result_regex.to_s).to include(described_class::NAME_REGEX.to_s)
      expect(result_regex.to_s).to include(described_class::CARD_NUMBER_REGEX.to_s)
      expect(result_regex.to_s).to include(described_class::AMOUNT_REGEX.to_s)
    end
  end

  describe "#charge_regex" do
    it "returns charge instruction parsing Regexp" do
      subject = described_class.new
      result_regex = subject.send(:charge_regex)

      expect(result_regex).to be_a(Regexp)
      expect(result_regex.to_s).to include(/charge/i.to_s)
      expect(result_regex.to_s).to include(described_class::NAME_REGEX.to_s)
      expect(result_regex.to_s).to include(described_class::AMOUNT_REGEX.to_s)
    end
  end

  describe "#credit_regex" do
    it "returns credit instruction parsing Regexp" do
      subject = described_class.new
      result_regex = subject.send(:credit_regex)

      expect(result_regex).to be_a(Regexp)
      expect(result_regex.to_s).to include(/credit/i.to_s)
      expect(result_regex.to_s).to include(described_class::NAME_REGEX.to_s)
      expect(result_regex.to_s).to include(described_class::AMOUNT_REGEX.to_s)
    end
  end

  describe "#instruction_regex" do
    it "returns an instruction parsing Regexp" do
      subject = described_class.new
      result_regex = subject.send(:instruction_regex)

      expect(result_regex).to be_a(Regexp)
      expect(result_regex.to_s).to include(subject.send(:add_regex).to_s)
      expect(result_regex.to_s).to include(subject.send(:charge_regex).to_s)
      expect(result_regex.to_s).to include(subject.send(:credit_regex).to_s)
    end
  end

  describe "#valid_instrucion?" do
    context "when a valid instruction is passed" do
      it "returns true" do
        subject = described_class.new

        expect(subject.send(:valid_instruction?, "Add Tom 4111111111111111 $1000")).to be true
        expect(subject.send(:valid_instruction?, "Add Lisa 5454545454545454 $3000")).to be true
        expect(subject.send(:valid_instruction?, "Add Quincy 1234567890123456 $2000")).to be true
        expect(subject.send(:valid_instruction?, "Charge Tom $500")).to be true
        expect(subject.send(:valid_instruction?, "Charge Tom $800")).to be true
        expect(subject.send(:valid_instruction?, "Charge Lisa $7")).to be true
        expect(subject.send(:valid_instruction?, "Credit Lisa $100")).to be true
        expect(subject.send(:valid_instruction?, "Credit Quincy $200")).to be true
      end
    end

    context "when an ivalid instruction is passed" do
      it "returns false" do
        subject = described_class.new

        expect(subject.send(:valid_instruction?, "")).to be false
        expect(subject.send(:valid_instruction?, "Add Tom $1000")).to be false
        expect(subject.send(:valid_instruction?, "Add Tom 41111111111111111")).to be false
        expect(subject.send(:valid_instruction?, "Add Tom 411111111111111117890 $1000")).to be false
        expect(subject.send(:valid_instruction?, "Lisa $7")).to be false
        expect(subject.send(:valid_instruction?, "Charge $7")).to be false
        expect(subject.send(:valid_instruction?, "Charge Lisa $")).to be false
        expect(subject.send(:valid_instruction?, "Charge Lisa 7")).to be false
        expect(subject.send(:valid_instruction?, "Credit Quincy $")).to be false
        expect(subject.send(:valid_instruction?, "Credit Quincy 200")).to be false
      end
    end
  end

  describe "#instruction_type" do
    context "when a valid instruction is passed" do
      it "returns the instruction type" do
        subject = described_class.new

        expect(subject.send(:instruction_type, "Add Tom 4111111111111111 $1000")).to eq :add
        expect(subject.send(:instruction_type, "Charge Lisa $7")).to eq :charge
        expect(subject.send(:instruction_type, "Credit Quincy $200")).to eq :credit
      end
    end

    context "when an invalid instruction is passed" do
      it "returns nil" do
        subject = described_class.new

        expect(subject.send(:instruction_type, "")).to be_nil
        expect(subject.send(:instruction_type, nil)).to be_nil
        expect(subject.send(:instruction_type, "Credit $200")).to be_nil
        expect(subject.send(:instruction_type, "Charge Lisa 7")).to be_nil
        expect(subject.send(:instruction_type, "Lend Quincy $200")).to be_nil
        expect(subject.send(:instruction_type, "Add Tom 411118382832311111111111 $1000")).to be_nil
      end
    end
  end

end
