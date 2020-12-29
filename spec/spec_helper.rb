require 'sequel'
require 'sqlite3'
require 'sequel_enum'

DB = Sequel.connect('sqlite://test.db')

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.order = 'random'

  config.before(:suite) do
    AbstractModel = Class.new(Sequel::Model)
    AbstractModel.require_valid_table = false
    AbstractModel.plugin :enum

    class RealModel < AbstractModel; end

    DB.create_table :items do
      primary_key :id
      column :name, String
      column :condition, Integer
      column :edition, Integer
    end

    class Item < Sequel::Model
      plugin :enum
    end
  end

  config.after(:suite) do
    DB.drop_table :items
  end
end
