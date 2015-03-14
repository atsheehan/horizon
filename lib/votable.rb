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
    fetch_vote(user).increment
  end

  def decrement_vote(user)
    fetch_vote(user).decrement
  end

  def vote_question
    is_question? ? self : question
  end

  private

  def fetch_vote(user)
    votes.find_or_create_by(user: user, votable_id: self.id, votable_type: self.class.to_s)
  end

  def is_question?
    self.class.to_s == "Question"
  end
end
