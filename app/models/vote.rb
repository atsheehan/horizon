class Vote < ActiveRecord::Base
  class UnknownVotable < Exception; end

  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates_uniqueness_of :user, scope: [:votable_id, :votable_type]

  def self.derive_votable(params)
    if params[:question_id].present?
      Question.find(params[:question_id])
    elsif params[:answer_id].present?
      Answer.find(params[:answer_id])
    else
      raise Vote::UnknownVotable
    end
  end

end
