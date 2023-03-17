# frozen_string_literal: true

require "user_list"
require "byebug"

RSpec.describe UserList do
  describe "#new" do
    it "creates an empty UserList" do
      subject = described_class.new

      expect(subject).to have_attributes(users: {})
    end
  end

  describe "#add_user" do
    context "when a User is passed" do
      it "returns the added User" do
        test_card1 = Card.new(number: "4111111111111111", limit: 1000)
        test_user1 = User.new(name: "Test Name1", card: test_card1)
        test_card2 = Card.new(number: "5454545454545454", limit: 1000)
        test_user2 = User.new(name: "Test Name2", card: test_card2)
        subject = described_class.new

        expect(subject.users.size).to eq 0
        expect(subject.add_user(user: test_user1)).to eq test_user1
        expect(subject.users.size).to eq 1
        expect(subject.add_user(user: test_user2)).to eq test_user2
        expect(subject.users.size).to eq 2
      end
    end

    context "when no User is passed" do
      it "returns nil" do
        subject = described_class.new

        expect(subject.users.size).to eq 0
        expect(subject.add_user(user: nil)).to be_nil
        expect(subject.users.size).to eq 0
      end
    end

    context "when a repeated User is passed" do
      it "returns nil (nothing is added)" do
        test_card1 = Card.new(number: "4111111111111111", limit: 1000)
        test_user1 = User.new(name: "Test Name1", card: test_card1)
        subject = described_class.new

        expect(subject.users.size).to eq 0
        expect(subject.add_user(user: test_user1)).to eq test_user1
        expect(subject.users.size).to eq 1
        expect(subject.add_user(user: test_user1)).to be_nil
        expect(subject.users.size).to eq 1
      end
    end

    context "when a User with an already used name is passed" do
      it "returns nil (nothing is added)" do
        test_card1 = Card.new(number: "4111111111111111", limit: 1000)
        test_user1 = User.new(name: "Test Name1", card: test_card1)
        test_card2 = Card.new(number: "5454545454545454", limit: 1000)
        test_user2 = User.new(name: "Test Name1", card: test_card2)
        subject = described_class.new

        expect(subject.users.size).to eq 0
        expect(subject.add_user(user: test_user1)).to eq test_user1
        expect(subject.users.size).to eq 1
        expect(subject.add_user(user: test_user2)).to be_nil
        expect(subject.users.size).to eq 1
      end
    end

    context "when a User with an already used Card number is passed" do
      it "returns nil (nothing is added)" do
        test_card1 = Card.new(number: "4111111111111111", limit: 1000)
        test_user1 = User.new(name: "Test Name1", card: test_card1)
        test_card2 = Card.new(number: "4111111111111111", limit: 1000)
        test_user2 = User.new(name: "Test Name2", card: test_card2)
        subject = described_class.new

        expect(subject.users.size).to eq 0
        expect(subject.add_user(user: test_user1)).to eq test_user1
        expect(subject.users.size).to eq 1
        expect(subject.add_user(user: test_user2)).to be_nil
        expect(subject.users.size).to eq 1
      end
    end
  end

  describe "#remove_user" do
    context "when an existing User is passed" do
      it "returns the removed User" do
        test_card1 = Card.new(number: "4111111111111111", limit: 1000)
        test_user1 = User.new(name: "Test Name1", card: test_card1)
        test_card2 = Card.new(number: "5454545454545454", limit: 1000)
        test_user2 = User.new(name: "Test Name2", card: test_card2)
        subject = described_class.new
        expect(subject.add_user(user: test_user1)).to eq test_user1
        expect(subject.add_user(user: test_user2)).to eq test_user2
        expect(subject.users.size).to eq 2

        expect(subject.remove_user(user: test_user1)).to eq test_user1
        expect(subject.users.size).to eq 1
      end
    end

    context "when an non-existing User is passed" do
      it "returns nil (nothing is removed)" do
        test_card1 = Card.new(number: "4111111111111111", limit: 1000)
        test_user1 = User.new(name: "Test Name1", card: test_card1)
        subject = described_class.new
        expect(subject.users.size).to eq 0

        expect(subject.remove_user(user: test_user1)).to be_nil
        expect(subject.users.size).to eq 0
      end
    end

    context "when no User is passed" do
      it "returns nil (nothing is removed)" do
        subject = described_class.new
        expect(subject.add_user(user: nil)).to eq nil
        expect(subject.users.size).to eq 0
      end
    end
  end

  describe "#find_user_by_name" do
    context "when an existing User name is passed" do
      it "returns the associated User" do
        test_card1 = Card.new(number: "4111111111111111", limit: 1000)
        test_user1 = User.new(name: "Test Name1", card: test_card1)
        test_card2 = Card.new(number: "5454545454545454", limit: 1000)
        test_user2 = User.new(name: "Test Name2", card: test_card2)
        subject = described_class.new
        expect(subject.add_user(user: test_user1)).to eq test_user1
        expect(subject.add_user(user: test_user2)).to eq test_user2

        expect(subject.find_user_by_name(name: "Test Name1")).to eq test_user1
      end
    end

    context "when an non-existing User name is passed" do
      it "returns nil" do
        test_card1 = Card.new(number: "4111111111111111", limit: 1000)
        test_user1 = User.new(name: "Test Name1", card: test_card1)
        subject = described_class.new
        expect(subject.add_user(user: test_user1)).to eq test_user1

        expect(subject.find_user_by_name(name: "TestName1")).to be_nil
      end
    end

    context "when an no User name is passed" do
      it "returns nil" do
        test_card1 = Card.new(number: "4111111111111111", limit: 1000)
        test_user1 = User.new(name: "Test Name1", card: test_card1)
        subject = described_class.new
        expect(subject.add_user(user: test_user1)).to eq test_user1

        expect(subject.find_user_by_name(name: nil)).to be_nil
      end
    end
  end

  describe "#invalid_user?" do
    context "when a valid User with a name & Card is passed" do
      it "returns false" do
        test_card1 = Card.new(number: "4111111111111111", limit: 1000)
        test_user1 = User.new(name: "Test Name1", card: test_card1)
        subject = described_class.new

        expect(subject.send(:invalid_user?, test_user1)).to be false
      end
    end

    context "when no User is passed" do
      it "returns true" do
        subject = described_class.new

        expect(subject.send(:invalid_user?, nil)).to be true
      end
    end

    context "when a User with no name is passed" do
      it "returns true" do
        test_card1 = Card.new(number: "4111111111111111", limit: 1000)
        test_user1 = User.new(name: "", card: test_card1)
        subject = described_class.new

        expect(subject.send(:invalid_user?, test_user1)).to be true
      end
    end

    context "when a User with no Card is passed" do
      it "returns true" do
        test_user1 = User.new(name: "Test Name1", card: nil)
        subject = described_class.new

        expect(subject.send(:invalid_user?, test_user1)).to be true
      end
    end
  end

  describe "#repeated_user_info?" do
    context "when a User with no repeated name or card number is passed" do
      it "returns false" do
        test_card1 = Card.new(number: "4111111111111111", limit: 1000)
        test_user1 = User.new(name: "Test Name1", card: test_card1)
        test_card2 = Card.new(number: "5454545454545454", limit: 1000)
        test_user2 = User.new(name: "Test Name2", card: test_card2)
        subject = described_class.new
        expect(subject.add_user(user: test_user1)).to eq test_user1

        expect(subject.send(:repeated_user_info?, test_user2)).to be false
      end
    end

    context "when a User with a repeated name is passed" do
      it "returns true" do
        test_card1 = Card.new(number: "4111111111111111", limit: 1000)
        test_user1 = User.new(name: "Test Name1", card: test_card1)
        test_card2 = Card.new(number: "5454545454545454", limit: 1000)
        test_user2 = User.new(name: "Test Name1", card: test_card2)
        subject = described_class.new
        expect(subject.add_user(user: test_user1)).to eq test_user1

        expect(subject.send(:repeated_user_info?, test_user2)).to be true
      end
    end

    context "when a User with a repeated Card number is passed" do
      it "returns true" do
        test_card1 = Card.new(number: "4111111111111111", limit: 1000)
        test_user1 = User.new(name: "Test Name1", card: test_card1)
        test_card2 = Card.new(number: "4111111111111111", limit: 1000)
        test_user2 = User.new(name: "Test Name2", card: test_card2)
        subject = described_class.new
        expect(subject.add_user(user: test_user1)).to eq test_user1

        expect(subject.send(:repeated_user_info?, test_user2)).to be true
      end
    end
  end


  describe "#print" do
    context "when called" do
      it "prints the list with their balances" do
        tom_card = Card.new(number: "4111111111111111", limit: 1000)
        tom_user = User.new(name: "Tom", card: tom_card)
        lisa_card = Card.new(number: "5454545454545454", limit: 3000)
        lisa_user = User.new(name: "Lisa", card: lisa_card)
        quincy_card = Card.new(number: "1234567890123456", limit: 2000)
        quincy_user = User.new(name: "Quincy", card: quincy_card)


        subject = described_class.new
        subject.add_user(user: tom_user)
        subject.add_user(user: lisa_user)
        subject.add_user(user: quincy_user)

        expect(subject.to_s).to eq "Lisa: $0\nQuincy: error\nTom: $0"

        tom_user.charge(500)
        tom_user.charge(800)
        lisa_user.charge(7)
        lisa_user.credit(100)
        quincy_user.credit(200)

        expect(subject.to_s).to eq "Lisa: $-93\nQuincy: error\nTom: $500"
      end
    end
  end
end
