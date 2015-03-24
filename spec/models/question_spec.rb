require "rails_helper"

describe Question do
  it_behaves_like "a votable object"

  describe '.filtered' do
    it 'delegates to the QuestionFilter filter method' do
      question_filter = stub
      newest = stub
      QuestionFilter.expects(:new).with("newest").returns(question_filter)
      question_filter.expects(:filter).returns(newest)
      expect(Question.filtered("newest")).to eq newest
    end
  end

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

  describe "#add_watcher" do
    it "successfully creates a QuestionWatching associated with question" do
      user = FactoryGirl.create(:user)
      question = FactoryGirl.create(:question)
      expect(QuestionWatching.count).to eq 0

      question.add_watcher(user)
      expect(QuestionWatching.count).to eq 1
    end
  end

  describe "#watched_by?" do
    let(:user) { FactoryGirl.create(:user) }
    let(:question) { FactoryGirl.create(:question) }

    context 'guest' do
      it "returns false" do
        expect(question.watched_by?(Guest.new)).to eq false
      end
    end

    context 'not a guest' do
      it "returns true if user is watching question" do
        QuestionWatching.create(user: user, question: question)
        expect(question.watched_by?(user)).to eq true
      end


      it "returns false if user is not watching this question" do
        expect(question.watched_by?(user)).to eq false
      end
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

  describe "#has_accepted_answer?" do
    let(:question) { FactoryGirl.create(:question) }
    let!(:answer) { FactoryGirl.create(:answer, question: question) }

    it 'returns true with accepted answer' do
      question.accepted_answer_id = answer.id
      question.save

      expect(question.has_accepted_answer?).to eq true
    end

    it 'returns false with no accepted answer' do
      expect(question.has_accepted_answer?).to eq false
    end
  end

  describe "editable_by?" do
    let(:author) { FactoryGirl.create(:user) }
    let(:student) { FactoryGirl.create(:user) }
    let(:question) { FactoryGirl.create(:question, user: author) }
    let(:ee) { FactoryGirl.create(:user, role: "admin") }

    context "admin" do
      it 'returns false if admin didnt write quesiton' do
        expect(question).to_not be_editable_by(ee)
      end

      it 'returns true if admin wrote question' do
        admin_question = FactoryGirl.create(:question, user: ee)
        expect(admin_question).to be_editable_by(ee)
      end
    end

    context "student who wrote question" do
      it 'returns true' do
        expect(question).to be_editable_by(author)
      end
    end

    context "student who didn't write question" do
      it 'returns false' do
        expect(question).to_not be_editable_by(student)
      end
    end

    context "as a visitor" do
      it 'returns false' do
        expect(question).to_not be_editable_by(Guest.new)
      end
    end
  end
end
