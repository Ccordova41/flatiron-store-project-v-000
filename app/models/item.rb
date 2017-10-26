# create_table "items", force: :cascade do |t|
#   t.string   "title"
#   t.integer  "inventory"
#   t.integer  "price"
#   t.integer  "category_id"
#   t.datetime "created_at",  null: false
#   t.datetime "updated_at",  null: false
# end

class Item < ActiveRecord::Base
  has_many :line_items
  has_many :carts, through: :line_items
  belongs_to :category

  # best to use query instead of iteration
  def self.available_items
    where("inventory > ?", 0)
  end

end
