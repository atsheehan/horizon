require "rails_helper"

RSpec.describe Tag, type: :model do
  it { should have_many(:lesson_tags) }
  it { should have_many(:lessons) }
end
