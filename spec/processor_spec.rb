# frozen_string_literal: true

require "processor"
require "byebug"

RSpec.describe Processor do
  subject(:processor) { described_class.new }

  describe "constants" do
    it "has Regex constants" do
      expect(described_class::NAME_REGEX).to be_a(Regexp)
      expect(described_class::AMOUNT_REGEX).to be_a(Regexp)
      expect(described_class::CARD_NUMBER_REGEX).to be_a(Regexp)
    end
  end

  describe "#add_regex" do
    it "returns add instruction parsing Regexp" do
      result_regex = processor.send(:add_regex)

      expect(result_regex).to be_a(Regexp)
      expect(result_regex.to_s).to include(/add/i.to_s)
      expect(result_regex.to_s).to include(described_class::NAME_REGEX.to_s)
      expect(result_regex.to_s).to include(described_class::CARD_NUMBER_REGEX.to_s)
      expect(result_regex.to_s).to include(described_class::AMOUNT_REGEX.to_s)
    end
  end

  describe "#charge_regex" do
    it "returns charge instruction parsing Regexp" do
      result_regex = processor.send(:charge_regex)

      expect(result_regex).to be_a(Regexp)
      expect(result_regex.to_s).to include(/charge/i.to_s)
      expect(result_regex.to_s).to include(described_class::NAME_REGEX.to_s)
      expect(result_regex.to_s).to include(described_class::AMOUNT_REGEX.to_s)
    end
  end

  describe "#credit_regex" do
    it "returns credit instruction parsing Regexp" do
      result_regex = processor.send(:credit_regex)

      expect(result_regex).to be_a(Regexp)
      expect(result_regex.to_s).to include(/credit/i.to_s)
      expect(result_regex.to_s).to include(described_class::NAME_REGEX.to_s)
      expect(result_regex.to_s).to include(described_class::AMOUNT_REGEX.to_s)
    end
  end

  describe "#instruction_regex" do
    it "returns an instruction parsing Regexp" do
      result_regex = processor.send(:instruction_regex)

      expect(result_regex).to be_a(Regexp)
      expect(result_regex.to_s).to include(processor.send(:add_regex).to_s)
      expect(result_regex.to_s).to include(processor.send(:charge_regex).to_s)
      expect(result_regex.to_s).to include(processor.send(:credit_regex).to_s)
    end
  end

  describe "#valid_instrucion?" do
    context "when a valid instruction is passed" do
      it "returns true" do
        expect(processor.send(:valid_instruction?, "Add Tom 4111111111111111 $1000")).to be true
        expect(processor.send(:valid_instruction?, "Add Lisa 5454545454545454 $3000")).to be true
        expect(processor.send(:valid_instruction?, "Add Quincy 1234567890123456 $2000")).to be true
        expect(processor.send(:valid_instruction?, "Charge Tom $500")).to be true
        expect(processor.send(:valid_instruction?, "Charge Tom $800")).to be true
        expect(processor.send(:valid_instruction?, "Charge Lisa $7")).to be true
        expect(processor.send(:valid_instruction?, "Credit Lisa $100")).to be true
        expect(processor.send(:valid_instruction?, "Credit Quincy $200")).to be true
      end
    end

    context "when an invalid instruction is passed" do
      it "returns false" do
        expect(processor.send(:valid_instruction?, "")).to be false
        expect(processor.send(:valid_instruction?, "Add Tom $1000")).to be false
        expect(processor.send(:valid_instruction?, "Add Tom 41111111111111111")).to be false
        expect(processor.send(:valid_instruction?, "Add Tom 411111111111111117890 $1000")).to be false
        expect(processor.send(:valid_instruction?, "Lisa $7")).to be false
        expect(processor.send(:valid_instruction?, "Charge $7")).to be false
        expect(processor.send(:valid_instruction?, "Charge Lisa $")).to be false
        expect(processor.send(:valid_instruction?, "Charge Lisa 7")).to be false
        expect(processor.send(:valid_instruction?, "Credit Quincy $")).to be false
        expect(processor.send(:valid_instruction?, "Credit Quincy 200")).to be false
      end
    end
  end

  describe "#instruction_type" do
    context "when a valid instruction is passed" do
      it "returns the instruction type" do
        expect(processor.send(:instruction_type, "Add Tom 4111111111111111 $1000")).to eq :add
        expect(processor.send(:instruction_type, "Charge Lisa $7")).to eq :charge
        expect(processor.send(:instruction_type, "Credit Quincy $200")).to eq :credit
      end
    end

    context "when an invalid instruction is passed" do
      it "returns nil" do
        expect(processor.send(:instruction_type, "")).to be_nil
        expect(processor.send(:instruction_type, "Add Tom 411111111111111117890 $1000")).to be_nil
        expect(processor.send(:instruction_type, "Charge Lisa $")).to be_nil
        expect(processor.send(:instruction_type, "Credit Quincy 200")).to be_nil
      end
    end
  end

  describe "#parse_instruction" do
    context "when a valid instruction is passed" do
      it "returns the command parsed as hash" do
        instruction_hash = processor.parse_instruction(instruction: "Charge Lisa $7")
        expect(instruction_hash).to eq({ instruction: :charge, user_name: "Lisa", charge_amount: "$7" })

        instruction_hash = processor.parse_instruction(instruction: "Credit Quincy $200")
        expect(instruction_hash).to eq({ instruction: :credit, user_name: "Quincy", credit_amount: "$200" })

        instruction_hash = processor.parse_instruction(instruction: "Add Tom 4111111111111111 $1000")
        expect(instruction_hash).to eq(
          { instruction: :add, user_name: "Tom", card_number: "4111111111111111", card_limit: "$1000" })
      end
    end

    context "when an invalid instruction is passed" do
      it "returns nil" do
        expect(processor.parse_instruction(instruction: "")).to be_nil
        expect(processor.parse_instruction(instruction: "Add Tom 411111111111111117890 $1000")).to be_nil
        expect(processor.parse_instruction(instruction: "Charge Lisa $")).to be_nil
        expect(processor.parse_instruction(instruction: "Credit Quincy 200")).to be_nil
      end
    end
  end

  describe "#parse_amount" do
    context "when $<Integer> is passed" do
      it "returns intenger amount" do
        expect(processor.send(:parse_amount, "$4300")).to eq 4300
      end
    end

    context "when invalid $<Integer> is passed" do
      it "returns 0" do
        expect(processor.send(:parse_amount, "$$4300")).to eq 0
        expect(processor.send(:parse_amount, "$43a00")).to eq 0
        expect(processor.send(:parse_amount, "test")).to eq 0
        expect(processor.send(:parse_amount, "")).to eq 0
      end
    end
  end

  describe "#process_instruction_hash" do
    context "when an 'add' instruction is passed" do
      it "calls #process_add and returns its result" do
        instruction_hash = processor.parse_instruction(instruction: "Add Tom 4111111111111111 $1000")
        new_user = processor.process_instruction_hash(instruction_hash: instruction_hash)

        expect(new_user.name).to eq "Tom"
        expect(new_user.card).to have_attributes(number: "4111111111111111", limit: 1000, balance: 0, valid: true)

        instruction_hash = processor.parse_instruction(instruction: "Add Quincy 1234567890123456 $2000")
        new_user = processor.process_instruction_hash(instruction_hash: instruction_hash)

        expect(new_user.name).to eq "Quincy"
        expect(new_user.card).to have_attributes(number: "1234567890123456", limit: 2000, balance: 0, valid: false)

        expect(processor.user_list.length).to eq 2
      end
    end

    context "when a 'charge' instruction is passed" do
      it "calls #process_charge and returns its result" do
        instruction_hash = processor.parse_instruction(instruction: "Add Tom 4111111111111111 $1000")
        new_user = processor.process_instruction_hash(instruction_hash: instruction_hash)

        instruction_hash = processor.parse_instruction(instruction: "Charge Tom $500")
        processor.process_instruction_hash(instruction_hash: instruction_hash)

        expect(new_user.card).to have_attributes(number: "4111111111111111", limit: 1000, balance: 500, valid: true)

        instruction_hash = processor.parse_instruction(instruction: "Charge Tom $500")
        processor.process_instruction_hash(instruction_hash: instruction_hash)

        expect(new_user.card).to have_attributes(number: "4111111111111111", limit: 1000, balance: 1000, valid: true)

        instruction_hash = processor.parse_instruction(instruction: "Charge Tom $500")
        processor.process_instruction_hash(instruction_hash: instruction_hash)

        expect(new_user.card).to have_attributes(number: "4111111111111111", limit: 1000, balance: 1000, valid: true)

        instruction_hash = processor.parse_instruction(instruction: "Add Quincy 1234567890123456 $2000")
        new_user = processor.process_instruction_hash(instruction_hash: instruction_hash)

        expect(new_user.name).to eq "Quincy"
        expect(new_user.card).to have_attributes(number: "1234567890123456", limit: 2000, balance: 0, valid: false)

        instruction_hash = processor.parse_instruction(instruction: "Charge Quincy $500")
        processor.process_instruction_hash(instruction_hash: instruction_hash)

        expect(new_user.card).to have_attributes(number: "1234567890123456", limit: 2000, balance: 0, valid: false)
        expect(new_user.balance).to eq "error"
      end
    end

    context "when a 'credit' instruction is passed" do
      it "calls #process_credit and returns its result" do
        instruction_hash = processor.parse_instruction(instruction: "Add Lisa 5454545454545454 $3000")
        new_user = processor.process_instruction_hash(instruction_hash: instruction_hash)

        instruction_hash = processor.parse_instruction(instruction: "Charge Lisa $7")
        processor.process_instruction_hash(instruction_hash: instruction_hash)

        expect(new_user.card).to have_attributes(number: "5454545454545454", limit: 3000, balance: 7, valid: true)

        instruction_hash = processor.parse_instruction(instruction: "Credit Lisa $100")
        processor.process_instruction_hash(instruction_hash: instruction_hash)

        expect(new_user.card).to have_attributes(number: "5454545454545454", limit: 3000, balance: -93, valid: true)

        instruction_hash = processor.parse_instruction(instruction: "Add Quincy 1234567890123456 $2000")
        new_user = processor.process_instruction_hash(instruction_hash: instruction_hash)

        expect(new_user.name).to eq "Quincy"
        expect(new_user.card).to have_attributes(number: "1234567890123456", limit: 2000, balance: 0, valid: false)

        instruction_hash = processor.parse_instruction(instruction: "Credit Quincy $200")
        processor.process_instruction_hash(instruction_hash: instruction_hash)

        expect(new_user.card).to have_attributes(number: "1234567890123456", limit: 2000, balance: 0, valid: false)
        expect(new_user.balance).to eq "error"
      end
    end
  end

  describe "#process_instruction" do
    context "when a valid instruction is passed, it is processed and its result returned" do
      it "returns the instruction result (a created User or its balance)" do
        expect(processor.process_instruction(instruction: "ADD Lisa 5454545454545454 $3000")).to be_a(User)
        expect(processor.process_instruction(instruction: "ChArGe Lisa $7")).to be 7
        expect(processor.process_instruction(instruction: "credit Lisa $100")).to be -93
      end
    end


    context "when a malformed instruction is passed" do
      it "returns nil" do
        expect(processor.process_instruction(instruction: "Create Tom 4111111111111111 $1000")).to be_nil
        expect(processor.process_instruction(instruction: "Add Lisa 1000")).to be_nil
        expect(processor.process_instruction(instruction: "Charge Quincy $")).to be_nil
        expect(processor.process_instruction(instruction: "")).to be_nil
      end
    end
  end
end
