class OrdersController < ApplicationController
  before_action :authenticate_customer!

  def index
    @orders = current_customer.orders
  end

  def show
  end
end
