namespace :horizon do
  desc "Import lessons from the curriculum repo on GitHub"
  task import_lessons: :environment do
    if ENV["CURRICULUM_DIR"]
      curriculum_dir = ENV["CURRICULUM_DIR"]
      Lesson.import_all!(File.join(curriculum_dir, "lessons"))
    else
      repo = ENV["CURRICULUM_GIT_REPO"] ||
        "https://github.com/LaunchAcademy/curriculum"

      Dir.mktmpdir("curriculum") do |tmpdir|
        if system("git", "clone", repo, File.join(tmpdir, "curriculum"))
          Lesson.import_all!(File.join(tmpdir, "curriculum", "lessons"))
        else
          puts "Failed to clone curriculum repo."
        end
      end
    end
  end
end
