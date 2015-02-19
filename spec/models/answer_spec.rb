require "rails_helper"

describe Answer do
  let(:question) { FactoryGirl.create(:question) }

  describe "#accepted?" do
    it "is true if the answer has been accepted" do
      answer = FactoryGirl.create(:answer, question: question)
      question.accepted_answer = answer
      question.save!

      expect(answer.accepted?).to eq(true)
    end

    it "is false if the answer has not been accepted" do
      answer = FactoryGirl.create(:answer)
      expect(answer.accepted?).to eq(false)
    end
  end
end
