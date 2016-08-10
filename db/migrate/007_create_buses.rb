class CreateBuses < ActiveRecord::Migration
  def self.up
    create_table "buses", force: :cascade do |t|
      t.string "name", limit: 25, null: false
    end
  end

  def self.down
    drop_table :buses
  end
end
