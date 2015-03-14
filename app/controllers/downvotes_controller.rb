class DownvotesController < ApplicationController
  before_action :authenticate_user!

  def create
    votable ||= Vote.derive_votable(params)
    if votable.decrement_vote(current_user)
      flash[:success] = "Downvote saved."
    else
      flash[:alert] = "You have already downvoted."
    end

    redirect_to question_path(votable.vote_question)
  end
end
