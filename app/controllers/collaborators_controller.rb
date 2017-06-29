class CollaboratorsController < ApplicationController

  include ApplicationHelper
  before_action :is_private_wiki_owner?

  def new
    @collaborator = Collaborator.new
  end

  def create
    @collaborator = Collaborator.new
    @collaborator.wiki_id = params[:collaborator][:wiki_id]

    unless User.find_by(email: params[:collaborator][:user_id])
      flash[:alert] = "User email could not be found."
      redirect_to edit_wiki_path(@collaborator.wiki_id)
    else
      @collaborator.user_id = User.find_by(email: params[:collaborator][:user_id]).id
      if is_collaborator?(@collaborator.user_id, @collaborator.wiki_id)
        flash[:alert] = "That user is already a collaborator on this wiki"
        redirect_to edit_wiki_path(@collaborator.wiki_id)
      else
        if @collaborator.save
          flash[:notice] = "Collaborator added to Wiki"
          redirect_to edit_wiki_path(@collaborator.wiki_id)
        else
          flash[:alert] = "Something went wrong while trying to add collaborator.  Please try again."
          render :new
        end
      end
    end
  end

  private

  def is_private_wiki_owner?
    wiki = Wiki.find_by(id: params[:collaborator][:wiki_id])
    if not_current_owner(wiki)
      flash[:alert] = "You are not the owner of this private wiki"
      redirect_to [wiki]
    end
  end
end
