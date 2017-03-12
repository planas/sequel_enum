require 'sequel'
require 'sqlite3'
require 'sequel_enum'

DB = Sequel.connect('sqlite://test.db')

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.order = 'random'

  config.before(:suite) do
    DB.create_table :items do
      primary_key :id
      column :name, String
      column :condition, Integer
      column :edition, Integer
    end
  end

  config.after(:suite) do
    DB.drop_table :items
  end
end
