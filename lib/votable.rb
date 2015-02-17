module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes,
      as: :votable,
      dependent: :destroy
  end

  def total_votes
    votes.sum(:score)
  end

  def increment_vote(user)
    vote = votes.find_or_create_by(user: user,
                            votable_id: self.id,
                            votable_type: self.class.to_s)
    if vote.score <= 0
      vote.score += 1
      vote.save
      true
    else
      false
    end
  end

  def decrement_vote(user)
    vote = votes.find_or_create_by(user: user,
                            votable_id: self.id,
                            votable_type: self.class.to_s)
    if vote.score >= 0 && vote.score <= 1
      vote.score -= 1
      vote.save
      true
    else
      false
    end
  end

  def vote_question
    if self.class.to_s == "Question"
      self
    else
      question
    end
  end
end
