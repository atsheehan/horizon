class User < ActiveRecord::Base
  include Feedster::Actor
  include Feedster::Recipient

  has_many :submissions, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :team_memberships, dependent: :destroy
  has_many :teams, through: :team_memberships
  has_many :assignments, through: :teams
  has_many :announcements, through: :teams
  has_many :assigned_lessons, through: :assignments, source: :lesson
  has_many :answers, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :announcement_receipts, dependent: :destroy
  has_many :question_queues, dependent: :destroy
  has_many :question_comments, dependent: :destroy
  has_many :question_watchings, dependent: :destroy
  has_many :answer_comments, dependent: :destroy

  has_many :identities, dependent: :destroy
  has_many :votes

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :token, presence: true
  validates :role, presence: true, inclusion: { in: ["member", "admin"] }

  before_validation :ensure_authentication_token

  scope :admins, -> { where(role: "admins") }

  def self.build_for_views(id)
    if id.present?
      find_by(id: id)
    else
      Guest.new
    end
  end

  def name
    [first_name, last_name].join(" ").strip
  end

  def to_param
    username
  end

  def guest?
    false
  end

  def to_param
    username
  end

  def ensure_authentication_token
    if token.blank?
      self.token = SecureRandom.urlsafe_base64
    end
  end

  def can_edit?(question)
    self == question.user || admin?
  end

  def admin?
    role == "admin"
  end

  def has_completed_lesson?(lesson)
    lesson.submissions.has_submission_from?(self)
  end

  def authorized_member?(auth_hash)
    if auth_hash["provider"] == 'github'
      belongs_to_org?(github_organization, auth_hash["credentials"]["token"])
    else
      if auth_hash["info"] && teams = auth_hash["info"]["teams"]
        offerings = auth_hash["info"]["product_offerings"]
        teams.any? { |team| team["name"] == 'Admins' } ||
          !offerings.empty?
      else
        false
      end
    end
  end

  def require_launch_pass?(auth_hash)
    auth_hash['provider'] == 'github' &&
      identities.where(provider: 'launch_pass').count > 0
  end

  def belongs_to_org?(organization, oauth_token)
    if organization.nil? || organization.empty?
      true
    else
      github_orgs(oauth_token).any? { |org| org["login"] == organization }
    end
  end

  def calendars
    result = []
    teams.each do |team|
      result << team.calendar if team.calendar
    end
    result.uniq
  end

  def latest_announcements(count)
    announcements.
      joins("LEFT JOIN announcement_receipts ON announcements.id = \
        announcement_receipts.announcement_id AND \
        announcement_receipts.user_id = #{id}").
      where("announcement_receipts.id IS NULL").
      order(created_at: :desc).limit(count)
  end

  def core_assignments
    assignments.where(required: true).order(due_on: :asc)
  end

  def non_core_assignments
    assignments.where(required: false).order(due_on: :asc)
  end

  private

  def github_orgs(token)
    JSON.parse(Net::HTTP.get(github_orgs_url(token)))
  end

  def github_orgs_url(token)
    URI("https://api.github.com/users/#{username}/orgs?access_token=#{token}")
  end

  def github_organization
    ENV["GITHUB_ORG"]
  end
end
