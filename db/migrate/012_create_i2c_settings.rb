class CreateI2cSettings < ActiveRecord::Migration
  def self.up
    create_table "i2c_settings", force: :cascade do |t|
      t.text    "address_w"
      t.text    "address_r"
      t.integer "frequency"
      t.integer "write_page_latency"
      t.integer "page_size"
      t.integer "total_size"
      t.integer "chip_id",               limit: 4, null: false
    end

    add_index "i2c_settings", ["chip_id"], name: "index_i2c_settings_on_chip_id", unique: true, using: :btree

    add_foreign_key "i2c_settings", "chips"
  end

  def self.down
    drop_table :i2c_settings
  end
end
