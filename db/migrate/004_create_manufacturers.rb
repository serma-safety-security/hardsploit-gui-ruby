class CreateManufacturers < ActiveRecord::Migration
  def self.up
    create_table "manufacturers", force: :cascade do |t|
      t.string "name", limit: 25, null: false
    end

    add_index "manufacturers", ["name"], name: "index_manufacturers_on_name", unique: true, using: :btree
  end

  def self.down
    drop_table :manufacturers
  end
end
