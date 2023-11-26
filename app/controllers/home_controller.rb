class HomeController < ApplicationController
  def index
    @products = Product.page(params[:page]).per(5)
  end
end
