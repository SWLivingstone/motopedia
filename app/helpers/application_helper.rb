module ApplicationHelper

  def require_sign_in
    unless current_user
      flash[:alert] = "You must be signed in to do that."
      redirect_to new_user_registration_path
    end
  end
end
