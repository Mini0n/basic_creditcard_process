# frozen_string_literal: true

require "card.rb"

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

end
