class CreateSwdSettings < ActiveRecord::Migration
  def self.up
    create_table "swd_settings", force: :cascade do |t|
      t.string  "cpu_id_address",       limit: 8
      t.string  "device_id_address",    limit: 8
      t.string  "memory_size_address",  limit: 8
      t.string  "memory_start_address", limit: 8
      t.integer "chip_id",              limit: 4, null: false
    end

    add_index "swd_settings", ["chip_id"], name: "index_swd_settings_on_chip_id", unique: true

    add_foreign_key "swd_settings", "chips"
  end

  def self.down
    drop_table :swd_settings
  end
end
