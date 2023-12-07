class CheckoutController < ApplicationController
  def create
    # Assuming params[:product_ids] is an array of product IDs
    product_ids = params[:product_ids]

    # Fetch the products based on the IDs
    @products = Product.where(id: product_ids)

    # Check if any products were found
    if @products.blank?
      redirect_to cart_index_path
      return
    end

    line_items = @products.map do |product|
      {
        price_data: {
          currency:     "cad", # Adjust the currency as needed
          product_data: {
            name:        product.name,
            description: product.description
          },
          unit_amount:  (product.price * 100).to_i # Amount in cents
        },
        quantity:   session[:cart][product.id.to_s].to_i
      }
    end

    @session = Stripe::Checkout::Session.create(
      payment_method_types: ["card"],
      mode:                 "payment", # Specify the mode as "payment" or "subscription"
      line_items:           line_items,
      success_url:          checkout_success_url,
      cancel_url:           checkout_cancel_url
    )

    respond_to do |format|
      format.html
    end
  end

  def success
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)
  end

  def cancel; end
end
