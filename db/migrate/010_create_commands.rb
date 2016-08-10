class CreateCommands < ActiveRecord::Migration
  def self.up
    create_table "commands", force: :cascade do |t|
      t.string  "name",         limit: 25, null: false
      t.text    "description"
      t.integer "bus_id",           limit: 4,  null: false
      t.integer "chip_id",  limit: 4,  null: false
    end

    add_index "commands", ["bus_id"], name: "index_commands_on_bus_id", using: :btree
    add_index "commands", ["chip_id"], name: "index_commands_on_chip_id", using: :btree

    add_foreign_key "commands", "buses"
    add_foreign_key "commands", "chips"

  end

  def self.down
    drop_table :commands
  end
end
