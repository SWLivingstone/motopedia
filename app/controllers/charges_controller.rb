class ChargesController < ApplicationController

  def new
  @stripe_btn_data = {
    key: "#{ Rails.configuration.stripe[:publishable_key] }",
    description: "Premium Membership - #{current_user.email}",
    amount: 500
  }
  end

  def create

    customer = Stripe::Customer.create(
      email: current_user.email,
      card: params[:stripeToken]
    )

    subscribe = Stripe::Subscription.create(
      :customer => customer.id,
      :plan => "premium-plan"
    )

    current_user.update(sub_id: subscribe.id, account: 'premium')

    flash[:notice] = "Thanks for all the money, #{current_user.email}! Feel free to pay me again."
    redirect_to root_path

    rescue Stripe::CardError => e
      flash[:alert] = e.message
      redirect_to new_charge_path
  end

  def destroy
    subscription = Stripe::Subscription.retrieve(current_user.sub_id)
    subscription.delete
    current_user.update(account: 'standard')
    private_wikis = Wiki.where(user_id: current_user.id)
    private_wikis.each do |wiki|
      wiki.update(private: false)
    end
    flash[:notice] = "You subscription has ended and you will no longer be billed"
    redirect_to root_path
  end
end
