class Submission < ActiveRecord::Base
  belongs_to :user
  belongs_to :lesson
  has_many :comments
  has_many :files, -> { order :filename }, class_name: "SourceFile"

  mount_uploader :archive, ArchiveUploader

  validates :user, presence: true
  validates :lesson, presence: true
  validates :archive, presence: true

  before_validation :save_body

  attr_accessor :body

  def inline_comments
    comments.where("line_number IS NOT NULL AND source_file_id IS NOT NULL")
  end

  def general_comments
    comments.where("line_number IS NULL OR source_file_id IS NULL")
  end

  def self.authorized_find(user, id)
    submission = viewable_by(user).find_by(id: id)

    if submission &&
        (user.admin? || user.has_completed_lesson?(submission.lesson))
      submission
    end
  end

  def self.viewable_by(user)
    if user.admin?
      all
    else
      where("user_id = ? OR public = true", user.id)
    end
  end

  def self.has_submission_from?(user)
    exists?(user: user)
  end

  private

  def save_body
    if body.present?
      Dir.mktmpdir do |tmpdir|
        tmp_file_path = File.join(tmpdir, "file001")
        File.write(tmp_file_path, body)

        archive_path = File.join(tmpdir, "submission.tar.gz")
        system("tar zcf #{archive_path} -C #{tmpdir} file001")

        self.archive = File.open(archive_path)
      end
    end
  end
end
