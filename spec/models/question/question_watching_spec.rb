require 'rails_helper'

describe QuestionWatching do
  it { should have_valid(:user).when(User.new) }
  it { should_not have_valid(:user).when(nil) }
end
