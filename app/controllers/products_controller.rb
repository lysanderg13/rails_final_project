class ProductsController < ApplicationController
  before_action :initialize_session
  before_action :increment_visit_count, only: %i[index show]
  before_action :load_cart

  def index
    @products = Product.page(params[:page]).per(20)
  end

  def index_category
    # Index action specific to a category
    @category_id = params[:category_id]
    @products = Product.where(category_id: @category_id)
    render 'index'
  end

  def show
    @product = Product.find(params[:id])
  end

  def add_to_cart
    id = params[:id].to_i
    quantity = params[:quantity].to_i
    quantity = 1 if quantity <= 0  # Set quantity to 1 if not provided or invalid
    session[:cart][id] ||= 0
    session[:cart][id] += quantity
    redirect_to cart_index_path
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
