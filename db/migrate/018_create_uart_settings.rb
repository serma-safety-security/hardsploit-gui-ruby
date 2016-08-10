class CreateUartSettings < ActiveRecord::Migration
  def self.up
    create_table "uart_settings", force: :cascade do |t|
      t.integer "baud_rate",     limit: 8
      t.integer "idle_line",     limit: 8
      t.integer "parity_bit",    limit: 8
      t.integer "parity_type",   limit: 8
      t.integer "stop_bits_nbr", limit: 8
      t.integer "word_size",     limit: 8
			t.integer "return_type",	 limit: 1
      t.integer "chip_id",       limit: 4, null: false
    end

    add_index "uart_settings", ["chip_id"], name: "index_uart_settings_on_chip_id", unique: true

    add_foreign_key "uart_settings", "chips"
  end

  def self.down
    drop_table :uart_settings
  end
end
