class CartController < ApplicationController
  before_action :initialize_session
  before_action :increment_visit_count, only: %i[index show]
  before_action :load_cart

  include CartsHelper

  def index
    @products = Product.page(params[:page]).per(20)
    @customers = current_customer
  end

  def show
    @product = Product.find(params[:id])
  end

  def remove_from_cart
    product_id = params[:id]
    session[:cart].delete(product_id)
    redirect_to cart_index_path, notice: "Product removed from cart."
  end

  private

  def initialize_session
    session[:visit_count] ||= 0
    session[:cart] ||= {}
  end

  def load_cart
    @cart = Product.find(session[:cart].keys)
  end

  def increment_visit_count
    session[:visit_count] += 1
    @visit_count = session[:visit_count]
  end
end
