class CreateSpiSettings < ActiveRecord::Migration
  def self.up
    create_table "spi_settings", force: :cascade do |t|
      t.integer "mode"
      t.text    "frequency"
      t.integer "write_page_latency"
      t.integer "command_read"
      t.integer "command_write"
      t.integer "command_write_enable"
      t.integer "command_erase"
      t.integer "erase_time"
      t.integer "page_size"
      t.integer "total_size"
      t.integer "is_flash"
      t.integer "chip_id",                 limit: 4, null: false
    end

    add_index "spi_settings", ["chip_id"], name: "index_spi_settings_on_chip_id", unique: true, using: :btree

    add_foreign_key "spi_settings", "chips"
  end

  def self.down
    drop_table :spi_settings
  end
end
