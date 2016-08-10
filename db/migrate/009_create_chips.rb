class CreateChips < ActiveRecord::Migration
  def self.up
    create_table "chips", force: :cascade do |t|
      t.string  "reference",   limit: 25,      null: false
      t.text	  "description"
      t.integer "voltage",                     null: false
      t.integer "manufacturer_id",  limit: 4,  null: false
      t.integer "package_id",       limit: 4,  null: false
      t.integer "chip_type_id",     limit: 4,  null: false
    end

    add_index "chips", ["reference"], name: "index_chips_on_reference", unique: true, using: :btree
    add_index "chips", ["manufacturer_id"], name: "index_chips_on_manufacturer_id", using: :btree
    add_index "chips", ["package_id"], name: "index_chips_on_package_id", using: :btree
    add_index "chips", ["chip_type_id"], name: "index_chips_on_chip_type_id", using: :btree

    add_foreign_key "chips", "manufacturers"
    add_foreign_key "chips", "packages"
    add_foreign_key "chips", "chip_types"
  end

  def self.down
    drop_table :chips
  end
end
