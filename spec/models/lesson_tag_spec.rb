require "rails_helper"

RSpec.describe LessonTag, type: :model do
  it { should belong_to(:tag) }
  it { should belong_to(:lesson) }
end
