class Question < ActiveRecord::Base
  belongs_to :user
  belongs_to :question_queue
  belongs_to :accepted_answer, class_name: "Answer"
  has_many :answers, dependent: :destroy
  has_many :question_comments, dependent: :destroy
  has_many :question_watchings, dependent: :destroy
  include Votable

  validates :title, presence: true, length: { in: 10..200 }
  validates :body, presence: true, length: { in: 15..10000 }
  validates :user, presence: true
  validates :category, inclusion: { in: QuestionFilter::CATEGORIES }

  validate :accepted_answer_belongs_to_question

  scope :queued, ->() {
    joins(:question_queue).
      where("questions.question_queue_id IS NOT NULL AND \
        question_queues.status NOT LIKE '%done%'")
  }

  def self.filtered(query)
    QuestionFilter.new(query).filter
  end

  def accepted_answer_belongs_to_question
    if accepted_answer && !answers.include?(accepted_answer)
      errors.add(:accepted_answer_id, "must belong to this question")
    end
  end

  def has_accepted_answer?
    accepted_answer_id ? true : false
  end

  def sorted_answers
    answers.sort_by { |answer| answer.accepted? ? 0 : 1 }
  end

  def self.unanswered
    where(answers_count: 0)
  end

  def queue
    question_queue.present? ? reset_question_queue : create_question_queue
  end

  def self.search(query)
    where("searchable @@ plainto_tsquery(?)", query)
  end

  def editable_by?(user)
    self.user == user
  end

  def add_watcher(user)
    question_watchings.find_or_create_by!(user: user)
  end

  def watched_by?(user)
    if user.guest?
      false
    else
      question_watchings.find_by(user: user).present?
    end
  end

  private

  def reset_question_queue
    question_queue.update_attributes(status: 'open', no_show_counter: 0)
  end

  def create_question_queue
    update_attributes(question_queue: QuestionQueue.create)
  end
end
