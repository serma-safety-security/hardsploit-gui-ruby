class CreateBytes < ActiveRecord::Migration
  def self.up
    create_table "bytes", force: :cascade do |t|
      t.integer "index",                        null: false
      t.text    "value",                        null: false
      t.text    "description"
      t.integer "iteration"
      t.integer "command_id",         limit: 4, null: false
    end

    add_index "bytes", ["command_id"], name: "index_bytes_on_command_id", using: :btree

    add_foreign_key "bytes", "commands"
  end

  def self.down
    drop_table :bytes
  end
end
