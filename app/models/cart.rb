# create_table :carts do |t|
#   t.integer :user_id
#   t.string :status, :default => "not submitted"
#
#   t.timestamps null: false
#
# create_table :line_items do |t|
#   t.integer :cart_id
#   t.integer :item_id
#   t.integer :quantity, default: 1
#
#   t.timestamps null: false

class Cart < ActiveRecord::Base
  has_many :line_items, dependent: :destroy
  #The :dependent option accepts the following values:
  # :destroy – all associated objects will removed one by one (in a separate query).
  #The appropriate callbacks will be run before and after deletion.
  has_many :items, through: :line_items
  belongs_to :user

  def total
    total = 0
    self.line_items.each do |line_item|
      total = total + (line_item.item.price * line_item.quantity)
      # item has many line_items, line_item belongs to item
    end
    total
  end

  def add_item(item_id)
    line_item = self.line_items.find_by(item_id: item_id)
    if line_item
      line_item.quantity += 1
      line_item.save
      line_item
    else
      self.line_items.build(item_id: item_id)
    end
  end

  def subtract
    self.line_items.each do |line_item|
      line_item.item.update(inventory: line_item.item.inventory - line_item.quantity)
    end
  end

  def checkout
    self.update(status: "submitted")
    self.subtract
  end

end
