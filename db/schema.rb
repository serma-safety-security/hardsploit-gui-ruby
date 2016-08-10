# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 18) do

  create_table "buses", force: :cascade do |t|
    t.string "name", limit: 25, null: false
  end

  create_table "bytes", force: :cascade do |t|
    t.integer "index",                 null: false
    t.text    "value",                 null: false
    t.text    "description"
    t.integer "iteration"
    t.integer "command_id",  limit: 4, null: false
  end

  add_index "bytes", ["command_id"], name: "index_bytes_on_command_id"

  create_table "chip_types", force: :cascade do |t|
    t.string "name", limit: 25, null: false
  end

  create_table "chips", force: :cascade do |t|
    t.string  "reference",       limit: 25, null: false
    t.text    "description"
    t.integer "voltage",                    null: false
    t.integer "manufacturer_id", limit: 4,  null: false
    t.integer "package_id",      limit: 4,  null: false
    t.integer "chip_type_id",    limit: 4,  null: false
  end

  add_index "chips", ["chip_type_id"], name: "index_chips_on_chip_type_id"
  add_index "chips", ["manufacturer_id"], name: "index_chips_on_manufacturer_id"
  add_index "chips", ["package_id"], name: "index_chips_on_package_id"
  add_index "chips", ["reference"], name: "index_chips_on_reference", unique: true

  create_table "commands", force: :cascade do |t|
    t.string  "name",        limit: 25, null: false
    t.text    "description"
    t.integer "bus_id",      limit: 4,  null: false
    t.integer "chip_id",     limit: 4,  null: false
  end

  add_index "commands", ["bus_id"], name: "index_commands_on_bus_id"
  add_index "commands", ["chip_id"], name: "index_commands_on_chip_id"

  create_table "i2c_settings", force: :cascade do |t|
    t.text    "address_w"
    t.text    "address_r"
    t.integer "frequency"
    t.integer "write_page_latency"
    t.integer "page_size"
    t.integer "total_size"
    t.integer "chip_id",            limit: 4, null: false
  end

  add_index "i2c_settings", ["chip_id"], name: "index_i2c_settings_on_chip_id", unique: true

  create_table "manufacturers", force: :cascade do |t|
    t.string "name", limit: 25, null: false
  end

  add_index "manufacturers", ["name"], name: "index_manufacturers_on_name", unique: true

  create_table "packages", force: :cascade do |t|
    t.string  "name",       limit: 25, null: false
    t.integer "pin_number",            null: false
    t.integer "shape",                 null: false
  end

  create_table "parallel_settings", force: :cascade do |t|
    t.integer "total_size"
    t.text    "total_size_unit"
    t.integer "page_size"
    t.integer "word_size"
    t.integer "read_latency"
    t.integer "write_latency"
    t.integer "chip_id",         limit: 4, null: false
  end

  add_index "parallel_settings", ["chip_id"], name: "index_parallel_settings_on_chip_id", unique: true

  create_table "pins", force: :cascade do |t|
    t.integer "number",                          null: false
    t.integer "chip_id",   limit: 4,             null: false
    t.integer "signal_id", limit: 4, default: 1, null: false
  end

  add_index "pins", ["chip_id"], name: "index_pins_on_chip_id"
  add_index "pins", ["signal_id"], name: "index_pins_on_signal_id"

  create_table "signals", force: :cascade do |t|
    t.string "name", null: false
    t.string "pin",  null: false
  end

  add_index "signals", ["name"], name: "index_signals_on_name", unique: true

  create_table "spi_settings", force: :cascade do |t|
    t.integer "mode"
    t.text    "frequency"
    t.integer "write_page_latency"
    t.integer "command_read"
    t.integer "command_write"
    t.integer "command_write_enable"
    t.integer "command_erase"
    t.integer "erase_time"
    t.integer "page_size"
    t.integer "total_size"
    t.integer "is_flash"
    t.integer "chip_id",              limit: 4, null: false
  end

  add_index "spi_settings", ["chip_id"], name: "index_spi_settings_on_chip_id", unique: true

  create_table "swd_settings", force: :cascade do |t|
    t.string  "cpu_id_address",       limit: 8
    t.string  "device_id_address",    limit: 8
    t.string  "memory_size_address",  limit: 8
    t.string  "memory_start_address", limit: 8
    t.integer "chip_id",              limit: 4, null: false
  end

  add_index "swd_settings", ["chip_id"], name: "index_swd_settings_on_chip_id", unique: true

  create_table "uart_settings", force: :cascade do |t|
    t.integer "baud_rate",     limit: 8
    t.integer "idle_line",     limit: 8
    t.integer "parity_bit",    limit: 8
    t.integer "parity_type",   limit: 8
    t.integer "stop_bits_nbr", limit: 8
    t.integer "word_size",     limit: 8
    t.integer "return_type",   limit: 1
    t.integer "chip_id",       limit: 4, null: false
  end

  add_index "uart_settings", ["chip_id"], name: "index_uart_settings_on_chip_id", unique: true

  create_table "uses", id: false, force: :cascade do |t|
    t.integer "signal_id"
    t.integer "bus_id"
  end

  add_index "uses", ["signal_id", "bus_id"], name: "index_uses_on_signal_id_and_bus_id", unique: true

end
