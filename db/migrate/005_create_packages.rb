class CreatePackages < ActiveRecord::Migration
  def self.up
    create_table "packages", force: :cascade do |t|
      t.string  "name",      limit: 25, null: false
      t.integer "pin_number",           null: false
      t.integer "shape",                null: false
    end
  end

  def self.down
    drop_table :packages
  end
end
