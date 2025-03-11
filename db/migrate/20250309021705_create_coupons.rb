class CreateCoupons < ActiveRecord::Migration[7.1]
  create_table :coupons do |t|
    t.string :name
    t.string :code
    t.float :percent_off
    t.float :dollars_off
    t.boolean :active

    t.timestamps
  end
end

# create_table "items", force: :cascade do |t|
#   t.string "name"
#   t.string "description"
#   t.float "unit_price"
#   t.bigint "merchant_id"
#   t.datetime "created_at", precision: nil, null: false
#   t.datetime "updated_at", precision: nil, null: false
#   t.index ["merchant_id"], name: "index_items_on_merchant_id"
# end
#   t.bigint "item_id"
#   t.bigint "invoice_id"
#   t.integer "quantity"
#   t.datetime "created_at", precision: nil, null: false
#   t.datetime "updated_at", precision: nil, null: false
#   t.index ["invoice_id"], name: "index_invoice_items_on_invoice_id"
#   t.index ["item_id"], name: "index_invoice_items_on_item_id"
# end
