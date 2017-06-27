module ApplicationHelper

  def require_sign_in
    unless current_user
      flash[:alert] = "You must be signed in to do that."
      redirect_to new_user_registration_path
    end
  end

  def is_standard_user?
    current_user.account == "standard"
  end

  def is_premium_user?
    current_user.account == "premium"
  end

  def not_current_owner(wiki)
    current_user.id != wiki.user_id
  end

  def wiki_owner(wiki)
    current_user.id == wiki.user_id
  end
end
