# frozen_string_literal: true

require "user"
require "byebug"

RSpec.describe User do
  describe "#new" do
    it "creates an User with a name & a Card" do
      test_card = Card.new(number: "4111111111111111", limit: 1000)
      subject = described_class.new(name: "Test Name", card: test_card)

      expect(subject).to have_attributes(name: "Test Name", card: test_card)
    end

    it "creates an empty User (no name and no Card)" do
      subject = described_class.new

      expect(subject).to have_attributes(name: /<unamed>\[[0-9]+\]/, card: nil)
    end
  end

  describe "#valid?" do
    context "when the User has a valid Card" do
      it "returns true" do
        test_card = Card.new(number: "4111111111111111", limit: 1000)
        subject = described_class.new(name: "Test Name", card: test_card)

        expect(subject.valid?).to be true
      end
    end

    context "when the User has an invalid Card" do
      it "returns false" do
        test_card = Card.new(number: "4111111111111112", limit: 1000)
        subject = described_class.new(name: "Test Name", card: test_card)

        expect(subject.valid?).to be false
      end
    end

    context "when the User has no Card" do
      it "returns false" do
        subject = described_class.new(name: "Test Name", card: nil)

        expect(subject.valid?).to be false
      end
    end
  end

  describe "#balance" do
    context "when the User has a valid Card" do
      it "returns User's Card balance" do
        test_card = Card.new(number: "4111111111111111", limit: 1000)
        subject = described_class.new(name: "Test Name", card: test_card)

        expect(subject&.card&.balance).to eq 0

        subject&.card&.charge(555)

        expect(subject&.card&.balance).to eq 555
        expect(subject.balance).to eq 555
      end
    end

    context "when the User has an invalid Card" do
      it "returns 'error'" do
        test_card = Card.new(number: "4111111111111112", limit: 1000)
        subject = described_class.new(name: "Test Name", card: test_card)

        expect(subject&.card&.balance).to eq 0

        subject&.card&.charge(555)

        expect(subject&.card&.balance).to eq 0
        expect(subject.balance).to eq "error"
      end
    end

    context "when the User has no Card" do
      it "returns 'error'" do
        subject = described_class.new(name: "Test Name", card: nil)

        expect(subject&.card&.balance).to be_nil

        subject&.card&.charge(555)

        expect(subject&.card&.balance).to be_nil
        expect(subject.balance).to eq "error"
      end
    end
  end

  describe "#charge" do
    context "when the User has a valid Card" do
      it "returns User's Card balance" do
        test_card = Card.new(number: "4111111111111111", limit: 1000)
        subject = described_class.new(name: "Test Name", card: test_card)

        expect(subject.balance).to eq 0
        expect(subject.charge(555)).to eq 555
        expect(subject&.card&.balance).to eq 555
        expect(subject.balance).to eq 555
      end
    end

    context "when the User has an invalid Card" do
      it "returns User's Card balance" do
        test_card = Card.new(number: "4111111111111112", limit: 1000)
        subject = described_class.new(name: "Test Name", card: test_card)

        expect(subject&.balance).to eq "error"
        expect(subject.charge(555)).to eq 0
        expect(subject&.card&.balance).to eq 0
        expect(subject.balance).to eq "error"
      end
    end

    context "when the User has no Card" do
      it "returns User's Card balance" do
        subject = described_class.new(name: "Test Name", card: nil)

        expect(subject&.balance).to eq "error"
        expect(subject&.charge(555)).to be_nil
        expect(subject&.card&.balance).to be_nil
        expect(subject.balance).to eq "error"
      end
    end
  end

  describe "#credit" do
    context "when the User has a valid Card" do
      it "returns User's Card balance" do
        test_card = Card.new(number: "4111111111111111", limit: 1000)
        subject = described_class.new(name: "Test Name", card: test_card)

        expect(subject.balance).to eq 0
        expect(subject.charge(555)).to eq 555
        expect(subject.balance).to eq 555
        expect(subject.credit(55)).to eq 500
        expect(subject&.card&.balance).to eq 500
        expect(subject.balance).to eq 500
      end
    end

    context "when the User has an invalid Card" do
      it "returns User's Card balance" do
        test_card = Card.new(number: "4111111111111112", limit: 1000)
        subject = described_class.new(name: "Test Name", card: test_card)

        expect(subject.balance).to eq "error"
        expect(subject.charge(555)).to eq 0
        expect(subject.balance).to eq "error"
        expect(subject.credit(55)).to eq 0
        expect(subject&.card&.balance).to eq 0
        expect(subject.balance).to eq "error"
      end
    end

    context "when the User has no Card" do
      it "returns User's Card balance" do
        subject = described_class.new(name: "Test Name", card: nil)

        expect(subject.balance).to eq "error"
        expect(subject.charge(555)).to be_nil
        expect(subject.balance).to eq "error"
        expect(subject.credit(55)).to be_nil
        expect(subject&.card&.balance).to be_nil
        expect(subject.balance).to eq "error"
      end
    end
  end

  describe "#to_s" do
    context "when the User has a valid Card" do
      it "returns '<User.name>: <User.balance>'" do
        test_card = Card.new(number: "4111111111111111", limit: 1000)
        subject = described_class.new(name: "Test Name", card: test_card)


        expect(subject.balance).to eq 0
        expect(subject.to_s).to eq "Test Name: $0"
        expect(subject.charge(555)).to eq 555
        expect(subject.balance).to eq 555
        expect(subject.to_s).to eq "Test Name: $555"
        expect(subject.credit(55)).to eq 500
        expect(subject.to_s).to eq "Test Name: $500"
      end
    end

    context "when the User has an invalid Card" do
      it "returns '<User.name>: <User.balance>'" do
        test_card = Card.new(number: "4111111111111112", limit: 1000)
        subject = described_class.new(name: "Test Name", card: test_card)


        expect(subject.balance).to eq "error"
        expect(subject.to_s).to eq "Test Name: error"
        expect(subject.charge(555)).to eq 0
        expect(subject.balance).to eq "error"
        expect(subject.to_s).to eq "Test Name: error"
        expect(subject.credit(55)).to eq 0
        expect(subject.to_s).to eq "Test Name: error"
      end
    end


    context "when the User has no Card" do
      it "returns '<User.name>: <User.balance>'" do
        subject = described_class.new(name: "Test Name", card: nil)

        expect(subject.balance).to eq "error"
        expect(subject.to_s).to eq "Test Name: error"
        expect(subject.charge(555)).to be_nil
        expect(subject.balance).to eq "error"
        expect(subject.to_s).to eq "Test Name: error"
        expect(subject.credit(55)).to be_nil
        expect(subject.to_s).to eq "Test Name: error"
      end
    end

    context "when the User has no name & no Card" do
      it "returns '<User.name>: <User.balance>'" do
        subject = described_class.new


        expect(subject.balance).to eq "error"
        expect(subject.to_s).to match(/<unamed>\[[0-9]+\]: error/)
        expect(subject.charge(555)).to be_nil
        expect(subject.balance).to eq "error"
        expect(subject.to_s).to match(/<unamed>\[[0-9]+\]: error/)
        expect(subject.credit(55)).to be_nil
        expect(subject.to_s).to match(/<unamed>\[[0-9]+\]: error/)
      end
    end
  end
end
