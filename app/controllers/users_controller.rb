class UsersController < ApplicationController
  include ApplicationHelper


  def show
    @user = current_user
    if current_user
      @filterrific = initialize_filterrific(
        Wiki.where(user_id: current_user.id),
        params[:filterrific],
        select_options: {
          sorted_by: Wiki.options_for_sorted_by,
        },
        available_filters: [:sorted_by, :search_query],
      ) or return

      @filterrific_collabs = initialize_filterrific(
      Wiki.joins("INNER JOIN collaborators ON collaborators.wiki_id = wikis.id AND collaborators.user_id = #{current_user.id}"),
        params[:filterrific],
        select_options: {
          sorted_by: Wiki.options_for_sorted_by,
        },
        available_filters: [:sorted_by, :search_query],
      ) or return

      @wikis_owned = @filterrific.find.page(params[:page])
      @wikis_collabs = @filterrific_collabs.find.page(params[:page])
    end
  end
end
