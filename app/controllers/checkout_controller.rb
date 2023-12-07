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
    # Ensure that params[:session_id] is present before attempting to retrieve the session
    if params[:session_id].present?
      # Retrieve the Stripe session using the session_id
      @session = Stripe::Checkout::Session.retrieve(params[:session_id])

      # Retrieve the payment intent associated with the session
      @payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)

      # You may want to perform additional checks or handle the success logic here

      # Render the success page
      render "success"
    else
      # Redirect to an error page or handle the situation where session_id is not present
    end
  rescue Stripe::StripeError => e
    # Handle any errors that might occur during retrieval
    Rails.logger.error("Stripe session retrieval failed: #{e.message}")
    redirect_to root_path, alert: 'Something went wrong. Please try again.'
  end

  def cancel; end
end
