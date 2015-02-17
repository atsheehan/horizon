class UpvotesController < ApplicationController
  before_action :authenticate_user!

  def create
    votable ||= Vote.derive_votable(params)
    if votable.increment_vote(current_user)
      flash[:success] = "Upvote saved."
    else
      flash[:alert] = "You have already upvoted."
    end

    redirect_to question_path(votable.vote_question)
  end
end
