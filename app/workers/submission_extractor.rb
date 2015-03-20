require "open3"

class SubmissionExtractor
  include Sidekiq::Worker

  def perform(submission_id)
    @submission = Submission.find(submission_id)

    @submission.archive.cache_stored_file!

    Dir.mktmpdir do |tmpdir|
      @tmpdir = tmpdir
      unpack_archive

      set_gitignored_files

      import_source_files
    end
  end

  private

  def unpack_archive
    archive_path = File.join(@tmpdir, "archive.tar.gz")
    system("cp #{@submission.archive.path} #{archive_path}")
    system("tar zxf #{archive_path} -C #{@tmpdir}")
    system("rm #{archive_path}")
  end

  def set_gitignored_files
    gitignore_file = File.join(@tmpdir, ".gitignore")
    if File.exist?(gitignore_file)
      @gitignore = File.readlines(gitignore_file).map { |l| l.chomp! }
    else
      @gitignore = []
    end
  end

  def import_source_files
    SourceFile.transaction do
      valid_source_files.each do |filename|
        filepath = File.join(@tmpdir, filename)

        file = @submission.files.find_or_initialize_by(filename: filename)
        file_size = File.stat(filepath).size

        if file_size == 0
          file.body = ""
        elsif file_size > 50000
          file.body = "File too large to display (#{file_size} bytes)"
        elsif binary?(filepath)
          file.body = "Binary file (#{file_size} bytes)"
        else
          file.body = File.read(filepath)
        end

        file.save!
      end
    end
  end

  def binary?(filepath)
    file_type, status = Open3.capture2e("file", filepath)
    !status.success? || !file_type.include?("text")
  end

  def valid_source_files
    find_files(nil, @tmpdir)
  end

  def find_files(prefix, dir)
    filenames(dir).flat_map do |filename|
      path = File.join(dir, filename)

      if File.directory?(path)
        if prefix
          find_files(File.join(prefix, filename), path)
        else
          find_files(filename, path)
        end
      else
        if prefix
          File.join(prefix, filename)
        else
          filename
        end
      end
    end
  end

  def filenames(dir)
    Dir.entries(dir).reject do |filename|
      filename == "." || filename == ".." || ignore?(filename)
    end
  end

  def ignore?(filename)
    ignored_files.any? { |pattern| pattern.match(filename) }
  end

  def ignored_files
    [".git", ".DS_Store", /\._.*/, /.*~/] + @gitignore
  end
end
