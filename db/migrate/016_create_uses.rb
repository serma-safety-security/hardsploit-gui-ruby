class CreateUses < ActiveRecord::Migration
  def self.up
    create_table "uses", id: false, force: :cascade do |t|
      t.integer "signal_id"
      t.integer "bus_id"
    end

    add_index "uses", ["signal_id", "bus_id"], name: "index_uses_on_signal_id_and_bus_id", unique: true, using: :btree

    add_foreign_key "uses", "signals"
    add_foreign_key "uses", "buses"
  end

  def self.down
    drop_table :uses
  end
end
