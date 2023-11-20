class HomeController < ApplicationController
  def index
    @products = Product.page(params[:page]).per(5)
    session[:visit_count] ||= 0
    session[:visit_count] += 1
    @visit_count = session[:visit_count]
  end
end
