require 'rails_helper'

describe AnswersController do
  describe '#destroy' do
    it 'it deletes the answer' do
      answer = FactoryGirl.create(:answer)
      session[:user_id] = answer.user.id

      expect{
        delete :destroy, id: answer.id, question_id: answer.question.id
      }.to change{Answer.count}.by(-1)
    end
  end
end
