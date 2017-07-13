class WelcomeController < ApplicationController
  def index
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, filter_html: true, strikethrough: true, highlight: true, quote: true, footnotes: true)
    @recent_updates = Wiki.order(updated_at: :desc).limit(5)
    @recently_created = Wiki.order(created_at: :desc).limit(5)
  end
end
