# app/controllers/checkout_controller.rb
class CheckoutController < ApplicationController
  include ActionView::Helpers::NumberHelper

  def create
    product_ids = params[:product_ids]
    @products = Product.where(id: product_ids)

    if @products.blank?
      redirect_to cart_index_path
      return
    end

    total_amount = calculate_total_amount(@products, current_customer)

    @session = Stripe::Checkout::Session.create(
      payment_method_types: ["card"],
      mode: "payment",
      line_items: generate_line_items(@products),
      success_url: checkout_success_url + '?session_id={CHECKOUT_SESSION_ID}',
      cancel_url: checkout_cancel_url,
    )

    @order = Order.new(customer: current_customer, order_date: Time.now, total: total_amount[:numeric_total])

    if params[:session_id].present?
      @order.payment_id = Stripe::PaymentIntent.retrieve(@session.payment_intent)
      @order.save
    end

    @products.each do |product|
      quantity = session[:cart][product.id.to_s].to_i
      OrderItem.create(order: @order, product: product, quantity: quantity)
    end

    @formatted_total = total_amount[:formatted_total]

    respond_to do |format|
      format.html
    end
  end

  def success
    if params[:session_id].present?
      @session = Stripe::Checkout::Session.retrieve(params[:session_id])
      @payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)
      render "success"
    else
      redirect_to root_path, alert: 'Something went wrong. Please try again.'
    end
  rescue Stripe::StripeError => e
    Rails.logger.error("Stripe session retrieval failed: #{e.message}")
    redirect_to root_path, alert: 'Something went wrong. Please try again.'
  end

  def cancel
    # Implement any specific logic for handling cancellations
  end

  private

  def generate_line_items(products)
    products.map do |product|
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
  end

  def calculate_total_amount(products, customer)
    subtotal = products.sum { |product| product.price * session[:cart][product.id.to_s].to_i }
    pst = calculate_pst(products, customer)
    gst = calculate_gst(products, customer)
    hst = calculate_hst(products, customer)

    # Calculate total without formatting
    total = subtotal + pst + gst + hst

    # Return both the numeric total and the formatted total
    {
      numeric_total: total,
      formatted_total: number_to_currency(total)
    }
  end

  # Add your methods for calculating taxes (calculate_pst, calculate_gst, calculate_hst) here
  def calculate_pst(cart, customer)
    subtotal = cart.sum { |product| product.price * (session[:cart][product.id.to_s] || 0) }

    # Get the tax rates for the customer's province
    pst_rate = customer.province.pst_rate

    # Calculate taxes based on the available tax rates
    taxes = 0.0

    taxes += subtotal * pst_rate if pst_rate > 0

    taxes
  end

  def calculate_gst(cart, customer)
    subtotal = cart.sum { |product| product.price * (session[:cart][product.id.to_s] || 0) }

    # Get the tax rates for the customer's province
    gst_rate = customer.province.gst_rate

    # Calculate taxes based on the available tax rates
    taxes = 0.0

    taxes += subtotal * gst_rate if gst_rate > 0

    taxes
  end

  def calculate_hst(cart, customer)
    subtotal = cart.sum { |product| product.price * (session[:cart][product.id.to_s] || 0) }

    # Get the tax rates for the customer's province
    hst_rate = customer.province.hst_rate

    # Calculate taxes based on the available tax rates
    taxes = 0.0

    taxes += subtotal * hst_rate if hst_rate > 0

    taxes
  end
end
