# frozen_string_literal: true

require "card.rb"
require "byebug"

RSpec.describe Card do
  describe "constants" do
    it "has DEFAULT_BALANCE constant" do
      expect(described_class::DEFAULT_BALANCE).to eq(0)
    end
  end

  describe "#new" do
    it "creates a Card with a valid number & limit" do
      subject = described_class.new(number: "4111111111111111", limit: 1000)

      expect(subject.is_a?(described_class)).to be true
      expect(subject).to have_attributes(number: "4111111111111111",
                                         limit: 1000, balance: 0, valid: true)
    end

    it "creates a Card with an invalid number & limit" do
      subject = described_class.new(number: "4111111111111112", limit: 1000)

      expect(subject.is_a?(described_class)).to be true
      expect(subject).to have_attributes(number: "4111111111111112",
                                         limit: 1000, balance: 0, valid: false)
    end

    it "creates a Card with a valid number & a non-integer limit" do
      subject = described_class.new(number: "4111111111111111", limit: 1000.43)

      expect(subject.is_a?(described_class)).to be true
      expect(subject).to have_attributes(number: "4111111111111111",
                                         limit: 0, balance: 0, valid: true)
    end

    it "creates a Card with a valid number & a negative limit" do
      subject = described_class.new(number: "4111111111111111", limit: -1000)

      expect(subject.is_a?(described_class)).to be true
      expect(subject).to have_attributes(number: "4111111111111111",
                                         limit: 0, balance: 0, valid: true)
    end

    it "creates a Card without a number or limit" do
      subject = described_class.new

      expect(subject.is_a?(described_class)).to be true
      expect(subject).to have_attributes(number: nil, limit: 0, balance: 0, valid: false)
    end
  end

  describe "new_limit" do
    context "when a valid Card limit is passed, it is returned" do
      it "returns the new limit" do
        subject = described_class.new

        expect(subject.send(:new_limit, 4300)).to eq 4300
      end
    end

    context "when an empty (nil) Card limit is passed" do
      it "returns zero" do
        subject = described_class.new

        expect(subject.send(:new_limit, nil)).to eq 0
      end
    end

    context "when a non-Integer Card limit is passed" do
      it "returns zero" do
        subject = described_class.new

        expect(subject.send(:new_limit, 4300.43)).to eq 0
      end
    end

    context "when a negative Card limit is passed" do
      it "returns zero" do
        subject = described_class.new

        expect(subject.send(:new_limit, -4300)).to eq 0
      end
    end
  end

  describe "#valid?" do
    context "when a valid card number is used" do
      it "returns true" do
        subject = described_class.new

        subject.number = "585227606647" # 12 digits
        expect(subject.valid?).to be true

        subject.number = "6015376071173" # 13 digits
        expect(subject.valid?).to be true

        subject.number = "30440335740157" # 14 digits
        expect(subject.valid?).to be true

        subject.number = "342581510871672" # 15 digits
        expect(subject.valid?).to be true

        subject.number = "4631538551364753" # 16 digits
        expect(subject.valid?).to be true

        subject.number = "67417205832681762" # 17 digits
        expect(subject.valid?).to be true

        subject.number = "676763182487285637" # 18 digits
        expect(subject.valid?).to be true

        subject.number = "6010430241237266856" # 19 digits
        expect(subject.valid?).to be true
      end
    end

    context "when an invalid car number is used" do
      it "returns false" do
        subject = described_class.new

        subject.number = nil # nil
        expect(subject.valid?).to be false

        subject.number = "" # empty
        expect(subject.valid?).to be false

        subject.number = "585227606641" # 12 digits
        expect(subject.valid?).to be false

        subject.number = "6015376071172" # 13 digits
        expect(subject.valid?).to be false

        subject.number = "30440335740153" # 14 digits
        expect(subject.valid?).to be false

        subject.number = "342581510871674" # 15 digits
        expect(subject.valid?).to be false

        subject.number = "4631538551364755" # 16 digits
        expect(subject.valid?).to be false

        subject.number = "67417205832681766" # 17 digits
        expect(subject.valid?).to be false

        subject.number = "676763182487285636" # 18 digits
        expect(subject.valid?).to be false

        subject.number = "6010430241237266858" # 19 digits
        expect(subject.valid?).to be false
      end
    end
  end

  describe "#charge" do
    context "when validly called it increases the balance of a Card object" do
      it "returns the Card's new balance" do
        subject = described_class.new(number: "4111111111111111", limit: 1000)

        expect(subject.balance).to eq 0
        expect(subject.charge(430)).to eq 430
        expect(subject.balance).to eq 430
      end
    end

    context "when charge adds a non-integer balance it is ignored" do
      it "returns the Card's balance" do
        subject = described_class.new(number: "4111111111111111", limit: 1000)

        expect(subject.balance).to eq 0
        expect(subject.charge(430.43)).to eq 0
        expect(subject.balance).to eq 0
      end
    end

    context "when charge adds a negative balance it is ignored" do
      it "returns the Card's balance" do
        subject = described_class.new(number: "4111111111111111", limit: 1000)

        expect(subject.balance).to eq 0
        expect(subject.charge(-430)).to eq 0
        expect(subject.balance).to eq 0
      end
    end

    context "when charge raises balance over Card limit it is ignored" do
      it "returns the Card's balance" do
        subject = described_class.new(number: "4111111111111111", limit: 1000)

        expect(subject.balance).to eq 0
        expect(subject.charge(4300)).to eq 0
        expect(subject.balance).to eq 0
      end
    end

    context "when charge adds to an invalid Card (invalid number) it is ignored" do
      it "returns the Card's balance (0)" do
        subject = described_class.new(number: "4111111111111112", limit: 1000)

        expect(subject.balance).to eq 0
        expect(subject.charge(430)).to eq 0
        expect(subject.balance).to eq 0
      end
    end
  end

  describe "#credit" do
    context "when validly called it substracts balance from a Card object" do
      it "returns the Card's new balance" do
        subject = described_class.new(number: "4111111111111111", limit: 1000)
        subject.charge(430)
        expect(subject.balance).to eq(430)

        expect(subject.credit(43)).to eq(387)
        expect(subject.balance).to eq(387)
      end
    end

    context "when credit substracts drops Card's balance below 0 Card's balance will be negative" do
      it "returns the Card's new balance (negative)" do
        subject = described_class.new(number: "4111111111111111", limit: 1000)
        subject.charge(430)
        expect(subject.balance).to eq(430)

        expect(subject.credit(443)).to eq(-13)
        expect(subject.balance).to eq -13
      end
    end

    context "when credit substracts a non-integer value it is ignored" do
      it "returns the Card's balance" do
        subject = described_class.new(number: "4111111111111111", limit: 1000)
        subject.charge(430)
        expect(subject.balance).to eq(430)

        expect(subject.credit(43.43)).to eq(430)
        expect(subject.balance).to eq(430)
      end
    end

    context "when credit substracts a negative balance it is ignored" do
      it "returns the Card's balance" do
        subject = described_class.new(number: "4111111111111111", limit: 1000)
        subject.charge(430)
        expect(subject.balance).to eq(430)

        expect(subject.credit(-43)).to eq(430)
        expect(subject.balance).to eq(430)
      end
    end

    context "when credit substracts to an invalid Card (invalid number) it is ignored" do
      it "returns the Card's balance (0)" do
        subject = described_class.new(number: "4111111111111112", limit: 1000)
        subject.charge(430)
        expect(subject.balance).to eq(0)

        expect(subject.credit(43)).to eq(0)
        expect(subject.balance).to eq(0)
      end
    end
  end
end
