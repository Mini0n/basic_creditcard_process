require "user.rb"
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

      expect(subject).to have_attributes(name: nil, card: nil)
    end
  end

  describe "#valid?" do
  end

  describe "#balance" do
  end

  describe "#charge" do
  end

  describe "#credit" do
  end
end
