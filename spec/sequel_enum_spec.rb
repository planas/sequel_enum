require 'spec_helper'

class Item < Sequel::Model
  plugin :enum
end

describe "sequel_enum" do
  let(:item) { Item.new }

  specify "class should provide reflection" do
    Item.enum :condition, [:mint, :very_good, :fair]
    Item.enums.should eq({ condition: { 0 => :mint, 1 => :very_good, 2 => :fair}})
  end

  specify "it accepts an array of symbols" do
    expect{
      Item.enum :condition, [:mint, :very_good, :good, :poor]
    }.not_to raise_error
  end

  specify "it accepts a hash of index => value" do
    expect{
      Item.enum :condition, 0 => :mint, 1 => :very_good, 2 => :good, 3 => :poor
    }.not_to raise_error
  end

  specify "it rejects an invalid hash" do
    expect{
      Item.enum :condition, { '0' => :mint }
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
    end

    describe "#column=" do
      context "with a valid value" do
        it "should set column to the value index" do
          item.condition = :mint
          item[:condition].should eq 0
        end
      end

      context "with an invalid value" do
        it "should set column to nil" do
          item.condition = :fair
          item[:condition].should be_nil
        end
      end
    end

    describe "#column" do
      context "with a valid index stored on the column" do
        it "should return its matching value" do
          item[:condition] = 1
          item.condition.should eq :very_good
        end
      end

      context "with an invalid index stored on the column" do
        it "should return nil" do
          item[:condition] = 10
          item.condition.should be_nil
        end
      end
    end

    describe "#column?" do
      context "when the actual value match" do
        it "should return true" do
          item.condition = :good
          item.good?.should eq true
        end
      end

      context "when the actual value doesn't match" do
        it "should return false" do
          item.condition = :mint
          item.poor?.should eq false
        end
      end
    end
  end
end
