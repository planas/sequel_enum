require 'spec_helper'

class Item < Sequel::Model
  plugin :enum
end

describe "sequel_enum" do
  let(:item) { Item.new }

  specify "class should provide reflection" do
    Item.enum :condition, [:mint, :very_good, :fair]
    expect(Item.enums).to eq({ condition: { :mint => 0, :very_good => 1, :fair => 2}})
  end

  specify "it accepts an array of symbols" do
    expect{
      Item.enum :condition, [:mint, :very_good, :good, :poor]
    }.not_to raise_error
  end

  specify "it accepts a hash of index => value" do
    expect{
      Item.enum :condition, :mint => 0, :very_good => 1, :good => 2, :poor => 3
    }.not_to raise_error
  end

  specify "it rejects an invalid hash" do
    expect{
      Item.enum :condition, { :mint => '0' }
    }.to raise_error(ArgumentError)
  end

  specify "it rejects when it's not an array or hash" do
    expect{
      Item.enum :condition, 'whatever'
    }.to raise_error(ArgumentError)
  end

  describe "methods" do
    before(:all) do
      Item.enum :condition, [:mint, :very_good, :good, :poor]
      Item.enum :edition, [:first, :second, :rare, :other]
    end

    describe "#initialize_set" do
      it "handles multiple enums" do
        i = Item.create(:condition => :mint, :edition => :first)

        expect(i[:condition]).to eq 0
        expect(i[:edition]).to eq 0
      end
    end

    describe "#update" do
      it "accepts strings" do
        i = Item.create(:condition => "mint")
        expect(i[:condition]).to eq 0
      end
      
      it "accepts integer values" do
        i = Item.create(:condition => 0)
        expect(i[:condition]).to eq 0
      end
      it "accepts only predefined integer values" do
        expect{
        i = Item.create(:condition => 4567)
        }.to raise_error(ArgumentError)
      end

      it "handles multiple enums" do
        i = Item.create(:condition => :mint, :edition => :first)
        i.update(:edition => :second)

        expect(i[:edition]).to eq 1
      end
    end

    describe "#column=" do
      context "with a valid value" do
        it "should set column to the value index" do
          item.condition = :mint
          expect(item[:condition]).to be 0
        end
      end

      context "with an invalid value" do
        it "should set column to nil" do
          item.condition = :fair
          expect(item[:condition]).to be_nil
        end
      end
    end

    describe "#column" do
      context "with a valid index stored on the column" do
        it "should return its matching value" do
          item[:condition] = 1
          expect(item.condition).to be :very_good
        end
      end

      context "with an invalid index stored on the column" do
        it "should return nil" do
          item[:condition] = 10
          expect(item.condition).to be_nil
        end
      end
    end
    describe "#column?(val)" do
      context "with symol values" do
        it "should return true " do
          item.condition = :good
          expect(item.condition? :good).to be true
        end
        it "should return false" do
          item.condition = :mint
          expect(item.condition? :poor).to be false
        end
      end
      context "with integer values" do
        it "should return true " do
          item.condition = :good
          expect(item.condition? 2).to be true
        end
        it "should return false" do
          item.condition = :good
          expect(item.condition? 0).to be false
        end
      end
      it "should raise ArgumentError" do
        expect{
            item.condition? "wrong_argument"
        }.to raise_error(ArgumentError)
      end
    end
    describe "#column?" do
      context "when the actual value match" do
        it "should return true" do
          item.condition = :good
          expect(item.good?).to be true
        end
      end

      context "when the actual value doesn't match" do
        it "should return false" do
          item.condition = :mint
          expect(item.poor?).to be false
        end
      end
    end
  end
end
