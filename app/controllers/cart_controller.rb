class CartController < ApplicationController

  before_action :require_not_admin

  def index
    @items = cart.items
  end

  def update
    increment_decrement
  end

  def empty
    session.delete(:cart)
    redirect_to '/cart'
  end

  def destroy
    session[:cart].delete(params[:id])
    redirect_to '/cart'
  end

  private

  def increment_decrement
    if params[:quantity] == "increase"
      cart.add_quantity(params[:id]) unless cart.limit_reached?(params[:id])
      redirect_to '/cart'
    elsif params[:quantity] == "decrease"
      cart.subtract_quantity(params[:id])
      return destroy if cart.quantity_zero?(params[:id])
      redirect_to '/cart'
    else
      add_item
      redirect_to "/items"
    end
  end

  def add_item
    item = Item.find(params[:id])
    cart.add_item(item.id.to_s)
    flash[:success] = "#{item.name} was successfully added to your cart"
  end
end
