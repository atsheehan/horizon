class Assignment < ActiveRecord::Base
  belongs_to :team
  belongs_to :lesson

  validates :team, presence: true
  validates :lesson, presence: true
  validates :required, inclusion: [true, false]
  validates :due_on, presence: true

  def submitted?(user)
    lesson.submissions.where(user: user).count > 0
  end

  def late?
    Time.zone.now > due_on
  end

  def core
    where(required: true)
  end

  def non_core
    where(required: false)
  end

  def reviewed?(user)
    Comment.count_by_sql([ADMIN_COMMENT_COUNT, lesson.id, user.id]) > 0
  end

  ADMIN_COMMENT_COUNT = <<SQL
SELECT
  COUNT(*)
FROM assignments
  JOIN lessons ON lessons.id = assignments.lesson_id
  JOIN submissions ON submissions.lesson_id = lessons.id
  JOIN comments ON comments.submission_id = submissions.id
  JOIN users AS commenters ON commenters.id = comments.user_id
  JOIN users AS submitters ON submitters.id = submissions.user_id
WHERE commenters.role = 'admin' AND lessons.id = ? AND submitters.id = ?
SQL

  def user_submissions
    User.find_by_sql([USER_SUBMISSION_QUERY, due_on, lesson_id, team_id])
  end

  USER_SUBMISSION_QUERY = <<SQL
SELECT
  users.username,
  subs.id AS submission_id,
  subs.comments_count,
  subs.created_at AS submission_time,
  COALESCE(subs.created_at <= ?, false) AS on_time
FROM users
  INNER JOIN team_memberships ON users.id = team_memberships.user_id
  INNER JOIN teams ON teams.id = team_memberships.team_id
  LEFT OUTER JOIN (SELECT * FROM submissions WHERE lesson_id = ?) subs ON subs.user_id = users.id WHERE teams.id = ?
ORDER BY users.username ASC, subs.created_at DESC
SQL

end
