class SearchController < ApplicationController
  def search
    @query = params[:search]
    @results = Product.where("name LIKE ?", "%#{@query}%")
  end
end
