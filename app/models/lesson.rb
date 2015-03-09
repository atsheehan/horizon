class Lesson < ActiveRecord::Base
  SUBMITTABLE_TYPES = ["challenge", "exercise"]
  LESSON_TYPES = ["article", "tutorial", "challenge", "exercise"]

  self.inheritance_column = :_type_disabled

  has_many :submissions, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :assignments, dependent: :destroy
  has_many :lesson_tags
  has_many :tags, through: :lesson_tags

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :body, presence: true
  validates :type, presence: true, inclusion: LESSON_TYPES

  validates :visibility, presence: true, inclusion: [
    "public", "assign"
  ]

  mount_uploader :archive, LessonUploader

  def to_param
    slug
  end

  def submissions_viewable_by(user)
    if user.admin?
      submissions
    else
      if submissions.has_submission_from?(user)
        submissions.where("user_id = ? OR public = true", user.id)
      else
        submissions.none
      end
    end
  end

  def accepts_submissions?
    SUBMITTABLE_TYPES.include?(type)
  end

  def self.public
    where(visibility: "public")
  end

  def self.visible_for(user)
    where("visibility = 'public' OR lessons.id IN (?)", user.assigned_lesson_ids)
  end

  def self.submittable
    where(type: SUBMITTABLE_TYPES)
  end

  def self.challenges
    type("challenge")
  end

  def self.search(query)
    where("searchable @@ plainto_tsquery(?)", query)
  end

  def self.type(type)
    where(type: type)
  end

  def self.tagged(tag_name)
    joins(:tags).where(tags: { name: tag_name })
  end

  def self.import_all!(lessons_dir)
    lessons = {}

    Dir.entries(lessons_dir).each do |filename|
      path = File.join(lessons_dir, filename)

      if File.directory?(path) && !filename.start_with?(".")
        lesson = import(path)
        lessons.merge!(lesson.slug => lesson)
      end
    end
  end

  def self.import(source_dir)
    slug = File.basename(source_dir)

    attributes = YAML.load_file(File.join(source_dir, ".lesson.yml"))
    content = File.read(File.join(source_dir, "#{slug}.md"))

    lesson = Lesson.find_or_initialize_by(slug: slug)
    lesson.body = content
    lesson.title = attributes["title"]
    lesson.description = attributes["description"]
    lesson.type = attributes["type"]
    lesson.visibility = attributes["visibility"] || "public"

    if lesson.accepts_submissions?
      Dir.mktmpdir("archive") do |tmpdir|
        parent_dir = File.dirname(source_dir)
        archive_path = File.join(tmpdir, "#{slug}.tar.gz")
        system("tar", "zcf", archive_path, "-C", parent_dir, slug)
        lesson.archive = File.open(archive_path)
      end
    end

    lesson.save!

    if attributes["tags"]
      lesson.generate_tags(attributes["tags"].split(", "))
    end
    lesson
  end

  def generate_tags(new_tags)
    self.tags = new_tags.map { |tag_name| Tag.find_or_create_by(name: tag_name) }
  end
end
