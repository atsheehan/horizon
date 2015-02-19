require "rails_helper"

describe Question do
  describe 'scopes' do
    describe 'queued' do
      it 'returns questions that are in the question_queue and not done' do
        qq1 = FactoryGirl.create(:question_queue, status: 'done')
        qq2 = FactoryGirl.create(:question_queue, status: 'open')
        qq3 = FactoryGirl.create(:question_queue, status: 'in-progress')
        q1 = FactoryGirl.create(:question, question_queue: qq1)
        q2 = FactoryGirl.create(:question, question_queue: qq2)
        q3 = FactoryGirl.create(:question, question_queue: qq3)
        FactoryGirl.create(:question)

        expect(Question.queued).to match_array([q2, q3])
      end
    end
  end

  describe "validations" do
    it "can only accept answers belonging to this question" do
      question = FactoryGirl.create(:question)
      valid_answer = FactoryGirl.create(:answer, question: question)
      invalid_answer = FactoryGirl.create(:answer)

      question.accepted_answer = valid_answer
      expect(question.valid?).to eq(true)

      question.accepted_answer = invalid_answer
      expect(question.valid?).to eq(false)
    end
  end

  describe "#sorted_answers" do
    it "returns accepted answers before others" do
      question = FactoryGirl.create(:question)
      unaccepted_answer = FactoryGirl.create(:answer, question: question)
      accepted_answer = FactoryGirl.create(:answer, question: question)

      question.accepted_answer = accepted_answer
      question.save!

      expect(question.sorted_answers).
        to eq([accepted_answer, unaccepted_answer])
    end
  end

  describe "#queue" do
    let(:question) { FactoryGirl.create(:question, user: user) }
    let(:team) { FactoryGirl.create(:team) }
    let(:user) { FactoryGirl.create(:user) }

    before do
      FactoryGirl.create(:team_membership, team: team, user: user)
    end

    context '#question_queue does not already exist for the question' do
      it 'creates a single question_queue' do
        expect {
          question.queue
        }.to change { QuestionQueue.count }.by(1)
      end
    end

    context '#question_queue already exists for the question' do
      it 'updates that question_queue' do
        question.queue
        question.
          question_queue.update_attributes(status: 'done', no_show_counter: 3)
        expect {
          question.queue
        }.to change { QuestionQueue.count }.by(0)
        expect(question.question_queue.status).to eq 'open'
        expect(question.question_queue.no_show_counter).to eq 0
      end
    end
  end
end
