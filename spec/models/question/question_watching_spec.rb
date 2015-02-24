require 'rails_helper'

describe QuestionWatching do
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:question) }
end
