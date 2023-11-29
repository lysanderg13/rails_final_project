class Customers::SessionsController < Devise::SessionsController
  def destroy
    super
  end
end
