# app/controllers/checkout_controller.rb
class CheckoutController < ApplicationController
  before_action :set_customer, only: [:success, :create, :calculate_total_amount]

  def create
    product_ids = params[:product_ids]
    @products = Product.where(id: product_ids)

    if @products.blank?
      redirect_to cart_index_path
      return
    end

    session[:checkout_products] = @products.map(&:id)

    customer = current_customer
    province = customer.province

    gst_rate = province.gst_rate
    pst_rate = province.pst_rate
    hst_rate = province.hst_rate

    line_items = @products.map do |product|
      [
        {
          price_data: {
            currency: 'cad',
            product_data: {
              name: product.name,
              description: product.description,
            },
            unit_amount: (product.price * 100).to_i,
          },
          quantity: session[:cart][product.id.to_s].to_i,
        },
        {
          price_data: {
            currency: 'cad',
            product_data: {
              name: 'GST',
              description: 'Goods and Services Tax',
            },
            unit_amount: (product.price * gst_rate * 100).to_i,
          },
          quantity: session[:cart][product.id.to_s].to_i,
        },
        {
          price_data: {
            currency: 'cad',
            product_data: {
              name: 'PST',
              description: 'Provincial Sales Tax',
            },
            unit_amount: (product.price * pst_rate * 100).to_i,
          },
          quantity: session[:cart][product.id.to_s].to_i,
        },
        {
          price_data: {
            currency: 'cad',
            product_data: {
              name: 'HST',
              description: 'Harmonized Sales Tax',
            },
            unit_amount: (product.price * hst_rate * 100).to_i,
          },
          quantity: session[:cart][product.id.to_s].to_i,
        }
      ]
    end.flatten

    total = line_items.sum { |item| item[:price_data][:unit_amount] * item[:quantity] }
    tax_amount = line_items.sum { |item| item[:price_data][:unit_amount] * item[:quantity] * (gst_rate + pst_rate + hst_rate) }

    @session = Stripe::Checkout::Session.create(
      payment_method_types: ["card"],
      mode: "payment",
      line_items: line_items,
      success_url: checkout_success_url + '?session_id={CHECKOUT_SESSION_ID}',
      cancel_url: checkout_cancel_url,
    )

    redirect_to @session.url, status: :see_other, allow_other_host: true
  end

  def success
    product_ids = session[:checkout_products]
    @products = Product.where(id: product_ids)

    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)

    if current_customer.present? && @products.present?
      # Calculate total based on the Stripe session
      total = @session.amount_total / 100.0

      # Fetch the customer's province and associated tax rates
      province = current_customer.province
      gst_rate = province.gst_rate
      pst_rate = province.pst_rate
      hst_rate = province.hst_rate

      # Calculate the total tax amount based on the sum of tax rates
      tax_rate = gst_rate + pst_rate + hst_rate
      tax_amount = total * tax_rate

      @order = current_customer.orders.create(
        order_num: params[:session_id],
        total: total,
        tax_amount: tax_amount,
        order_date: Date.current
      )
        # Associate products with the order
      @products.each do |product|
        order_item = @order.order_items.build(product: product, quantity: session[:cart][product.id.to_s].to_i)
        order_item.price = product.price
        order_item.save
      end
      session.delete(:cart)
    end
    session.delete(:checkout_products)
  end

  def cancel
  end

  private

  def set_customer
    @customer = current_customer
  end
end
