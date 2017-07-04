class WikisController < ApplicationController
  include ApplicationHelper
  require 'redcarpet'

  before_action :require_sign_in, except: [:show, :index]
  before_action :is_private_wiki_owner_or_collaborator? , only: [:edit, :update, :destroy]

  def show
    @wiki = Wiki.find(params[:id])
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, filter_html: true, strikethrough: true, highlight: true, quote: true, footnotes: true)
  end

  def index
    @wikis = Wiki.all
  end

  def new
    @wiki = Wiki.new
  end

  def create
    @wiki = Wiki.new(wiki_params)
    @wiki.user_id = current_user.id

    if @wiki.save
      flash[:notice] = "New wiki created!"
      redirect_to [@wiki]
    else
      flash.now[:alert] = "An error occured while trying to create the wiki.  Please try again."
      render :new
    end
  end

  def edit
    @wiki = Wiki.find(params[:id])
  end

  def update
    @wiki = Wiki.find(params[:id])
    @wiki.assign_attributes(wiki_params)

    unless Collaborator.find_by(user_id: current_user.id, wiki_id: @wiki.id)
      Collaborator.create!(user_id: current_user.id, wiki_id: @wiki.id)
    end


    if @wiki.save
      flash[:notice] = "Entry was updated"
      redirect_to [@wiki]
    else
      flash.now[:alert] = "An error occured while trying to update the wiki.  Please try again."
      render :new
    end
  end

  def destroy
    @wiki = Wiki.find(params[:id])

    if @wiki.destroy
      flash[:notice] = "#{@wiki.title} was removed from Motopedia"
      redirect_to wikis_path
    else
      flash[:notice] = "An error occured while attempting to delete the entry.  Please try agian"
      render :show
    end
  end

  private

  def wiki_params
    params.require(:wiki).permit!
  end

  def is_private_wiki_owner_or_collaborator?
    wiki = Wiki.find(params[:id])
    if wiki.private
      unless (wiki_owner(wiki) || is_collaborator?(current_user.id, wiki.id))
        flash[:alert] = "You are not the owner or a collaborator of this private wiki"
        redirect_to [wiki]
      end
    end
  end
end
