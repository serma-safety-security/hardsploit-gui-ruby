class CreateChipTypes < ActiveRecord::Migration
  def self.up
    create_table "chip_types", force: :cascade do |t|
      t.string "name", limit: 25, null: false
    end
  end

  def self.down
    drop_table :chip_types
  end
end
