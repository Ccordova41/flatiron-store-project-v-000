class LineItemsController < ApplicationController
  def create
    cart = current_user.current_cart
    if !cart
      cart = current_user.create_current_cart
      current_user.save
      cart.add_item(params[:item_id])
      cart.total
      cart.save
    else
      cart.add_item(params[:item_id])
      cart.total
      cart.save
    end
    redirect_to cart_path(cart)
  end
end
