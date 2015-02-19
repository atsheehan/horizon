class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      redirect_to dashboard_path
    else
      @content = File.read(Rails.root.join("db/pages/getting-started.md"))
      render :start
    end
  end

  def start
    @content = File.read(Rails.root.join("db/pages/getting-started.md"))
  end

  def dailies
    @content = File.read(Rails.root.join("db/pages/daily-summaries.md"))
  end
end
