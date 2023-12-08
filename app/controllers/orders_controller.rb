class OrdersController < ApplicationController
  def index
    @order = current_customer.orders
  end

  def show
    @orders = current_customer.orders.find(params[:id])
  end
end
