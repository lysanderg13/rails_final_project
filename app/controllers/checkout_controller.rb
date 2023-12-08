# app/controllers/checkout_controller.rb
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
        quantity: session[:cart][product.id.to_s].to_i,
        price_data: {
          currency: "cad",
          product_data: {
            name: product.name,
            description: product.description
          },
          unit_amount: (product.price * 100).to_i
        }
      }
    end

    # Save order and address details
    @order = Order.new(customer: current_customer, order_date: Time.now, total: calculate_total_amount)

    # Create the Stripe Checkout session
    @session = Stripe::Checkout::Session.create(
      payment_method_types: ["card"],
      mode: "payment", # Specify the mode as "payment" or "subscription"
      line_items: line_items,
      success_url: checkout_success_url + '?session_id={CHECKOUT_SESSION_ID}',
      cancel_url: checkout_cancel_url,
    )
    # Store Stripe payment ID in the order
    if params[:session_id].present?
      @order.payment_id = Stripe::PaymentIntent.retrieve(@session.payment_intent)
      @order.save
    end

    @products.each do |product|
      quantity = session[:cart][product.id.to_s].to_i
      OrderItem.create(order: @order, product: product, quantity: quantity)
    end

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
      redirect_to root_path, alert: 'Something went wrong. Please try again.'# Redirect to an error page or handle the situation where session_id is not present
    end
  rescue Stripe::StripeError => e
    # Handle any errors that might occur during retrieval
    Rails.logger.error("Stripe session retrieval failed: #{e.message}")
    redirect_to root_path, alert: 'Something went wrong. Please try again.'
  end

  def cancel
    # Implement any specific logic for handling cancellations
  end

  private

  def calculate_total_amount
    # Calculate total amount based on the products in the cart
    # You need to adjust this based on your business logic
    @products.sum { |product| product.price * session[:cart][product.id.to_s].to_i }
  end
end
