class CreateSignals < ActiveRecord::Migration
  def self.up
    create_table "signals", force: :cascade do |t|
      t.string "name", null: false
      t.string "pin",  null: false
    end

    add_index "signals", ["name"], name: "index_signals_on_name", unique: true, using: :btree
  end

  def self.down
    drop_table :signals
  end
end
