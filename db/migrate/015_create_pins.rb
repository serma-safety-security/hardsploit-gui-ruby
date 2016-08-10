class CreatePins < ActiveRecord::Migration
  def self.up
    create_table "pins", force: :cascade do |t|
      t.integer "number",                          null: false
      t.integer "chip_id",   limit: 4,             null: false
      t.integer "signal_id", limit: 4, default: 1, null: false
    end

    add_index "pins", ["chip_id"], name: "index_pins_on_chip_id", using: :btree
    add_index "pins", ["signal_id"], name: "index_pins_on_signal_id", using: :btree

    add_foreign_key "pins", "chips"
    add_foreign_key "pins", "signals"
  end

  def self.down
    drop_table :pins
  end
end
