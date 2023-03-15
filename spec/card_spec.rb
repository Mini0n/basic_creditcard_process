# frozen_string_literal: true

require "card.rb"
require "byebug"

RSpec.describe Card do

  it "creates a Card" do
    subject = described_class.new(number: "4111111111111111", limit: 1000)

    expect(subject.is_a?(Card)).to be true
    expect(subject).to have_attributes(number: "4111111111111111",
                                       limit: 1000, balance: 0, valid: true)
  end

  describe "#valid?" do
    context "when a valid card number is used" do
      it "returns true" do
        subject = described_class.new(number: "4111111111111111")

        expect(subject.valid?).to be true
      end
    end

    context "when an invalid car number is used" do
      it "returns false" do
        subject = described_class.new(number: "4111111111111112")

        expect(subject.valid?).to be false
      end
    end
  end

  describe "#charge" do
    context "increases the balance of a Card object" do
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
    context "substracts balance from a Card object" do
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
