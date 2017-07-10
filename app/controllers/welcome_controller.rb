class WelcomeController < ApplicationController
  def index
    @recent_updates = Wiki.order(updated_at: :desc).limit(5)
    @recently_created = Wiki.order(created_at: :desc).limit(5)
  end
end
