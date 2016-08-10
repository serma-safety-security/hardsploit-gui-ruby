class CreateParallelSettings < ActiveRecord::Migration
  def self.up
    create_table "parallel_settings", force: :cascade do |t|
      t.integer "total_size"
      t.text    "total_size_unit"
      t.integer "page_size"
      t.integer "word_size"
      t.integer "read_latency"
      t.integer "write_latency"
      t.integer "chip_id",            limit: 4, null: false
    end

    add_index "parallel_settings", ["chip_id"], name: "index_parallel_settings_on_chip_id", unique: true, using: :btree

    add_foreign_key "parallel_settings", "chips"
  end

  def self.down
    drop_table :parallel_settings
  end
end
