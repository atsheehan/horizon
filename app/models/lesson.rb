class Lesson < ActiveRecord::Base
  SUBMITTABLE_TYPES = ["challenge", "exercise"]

  self.inheritance_column = :_type_disabled

  has_many :submissions, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :assignments, dependent: :destroy

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :body, presence: true
  validates :type, presence: true, inclusion: [
    "article", "tutorial", "challenge", "exercise"
  ]

  validates :position, presence: true, numericality: {
    greater_than_or_equal_to: 1
  }

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
    where("visibility = 'public' OR id IN (?)", user.assigned_lesson_ids)
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

  def self.import_all!(lessons_dir)
    lessons = {}
    dependencies = {}

    Dir.entries(lessons_dir).each do |filename|
      path = File.join(lessons_dir, filename)

      if File.directory?(path) && !filename.start_with?(".")
        lesson, lesson_dependencies = import(path)
        lessons.merge!(lesson.slug => lesson)
        dependencies.merge!(lesson_dependencies)
      end
    end

    order_lessons(dependencies).each_with_index do |slug, position|
      lesson = lessons[slug]
      lesson.position = position + 1
      lesson.save!
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
    lesson.position = attributes["position"]
    lesson.visibility = attributes["visibility"] || "public"

    if lesson.accepts_submissions?
      Dir.mktmpdir("archive") do |tmpdir|
        parent_dir = File.dirname(source_dir)
        archive_path = File.join(tmpdir, "#{slug}.tar.gz")
        system("tar", "zcf", archive_path, "-C", parent_dir, slug)
        lesson.archive = File.open(archive_path)
      end
    end

    if attributes["depends"]
      dependencies = attributes["depends"].split(",").map(&:strip)
    else
      dependencies = []
    end

    [lesson, { lesson.slug => dependencies }]
  end

  def self.order_lessons(lesson_prereqs)
    # This method uses the topological sort algorithm to produce a
    # linear ordering of lessons given their dependencies.  The
    # lessons_prereqs param is a hash where the key is the lesson slug
    # and the value is an array of dependencies:
    #
    # lesson_prereqs = { "foo" => ["bar"], "bar" => ["baz"], "baz" => [] }

    ordered = []
    next_lessons = []

    lesson_prereqs.each do |lesson, prereqs|
      if prereqs.empty?
        next_lessons.push(lesson)
      end
    end

    next_lessons.sort!

    while !next_lessons.empty?
      next_lesson = next_lessons.shift
      ordered.push(next_lesson)

      lesson_prereqs.each do |lesson, prereqs|
        if prereqs.include?(next_lesson)
          prereqs.delete(next_lesson)

          if prereqs.empty?
            next_lessons.push(lesson)
          end
        end
      end
    end

    ordered
  end
end
