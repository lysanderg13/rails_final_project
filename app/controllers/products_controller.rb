class ProductsController < ApplicationController
  before_action :initialize_session
  before_action :increment_visit_count, only: %i[index show]
  before_action :load_cart

  def index
    @products = Product.page(params[:page]).per(20)
  end

  def show
    @product = Product.find(params[:id])
  end

  def add_to_cart
    session[:cart] << params[:id]
    redirect_to cart_index_path
  end

  private

  def initialize_session
    session[:visit_count] ||= 0
    session[:cart] ||= []
  end

  def load_cart
    @cart = Product.find(session[:cart])
  end

  def increment_visit_count
    session[:visit_count] += 1
    @visit_count = session[:visit_count]
  end
end
