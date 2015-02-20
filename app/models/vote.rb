class Vote < ActiveRecord::Base
  class UnknownVotable < Exception; end

  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates_uniqueness_of :user, scope: [:votable_id, :votable_type]

  after_update :update_vote_cache

  def self.derive_votable(params)
    if params[:question_id].present?
      Question.find(params[:question_id])
    elsif params[:answer_id].present?
      Answer.find(params[:answer_id])
    else
      raise Vote::UnknownVotable
    end
  end

  def update_vote_cache
    if score_changed?
      votable.vote_cache = votable.total_votes
      votable.save!
    end
  end

  def increment
    upvote_cast? ? update_attributes(score: self.score += 1) : false
  end

  def upvote_cast?
    score <= 0
  end

  def decrement
    downvote_cast? ? update_attributes(score: self.score -= 1) : false
  end

  def downvote_cast?
    score >= 0
  end
end
