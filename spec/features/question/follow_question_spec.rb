require 'rails_helper'


feature 'following a question' do
  context 'as an authorized user' do
    scenario 'creating question automatically adds it to my watch list'
    scenario 'I can watch other peoples questions'
  end
end
