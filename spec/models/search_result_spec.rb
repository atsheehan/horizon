require 'rails_helper'

describe SearchResult do
  describe 'attr_readers' do
    let(:search_result) { SearchResult.new('javascript', 'challenge', nil) }

    it 'has query' do
      expect(search_result.query).to eq('javascript')
    end

    it 'has type' do
      expect(search_result.type).to eq('challenge')
    end
  end

  describe '#lessons' do
    let(:search_result) { SearchResult.new(query, type, user) }
    let(:query) { 'article'}
    let(:type) { nil }

    context "no user" do
      let(:user) { Guest.new }

      it 'returns only public lessons' do
        public_lessons = [FactoryGirl.create(:lesson)].map{|l|l.id}
        FactoryGirl.create(:lesson, visibility: 'assign')
        expect(search_result.lessons.map{|l| l.id}).to match_array public_lessons
      end
    end

    context "user does not have access to lessons" do
      let(:user) { FactoryGirl.create(:user) }

      it 'only returns lessons assigned to user' do
        team_membership = FactoryGirl.create(:team_membership, user: user)
        lesson = FactoryGirl.create(:assignment, team: team_membership.team).lesson
        lesson.update_attributes(visibility: 'assign')
        FactoryGirl.create(:lesson, visibility: 'assign')

        expect(search_result.lessons.map{|l| l.id}).
          to match_array [lesson].map{|l| l.id}
      end
    end

    context "user has access to lessons" do
      let(:user) { FactoryGirl.create(:user) }

      context "type filter is not set" do
        let(:query) { 'javascript'}

        it 'returns the searched lessons' do
          relevant_lesson = FactoryGirl.create(:lesson, title: "Javascript stuff")
          other_lesson = FactoryGirl.create(:lesson, title: "Rails stuff")

          expect(search_result.lessons.map{|l| l.id}).
            to match_array [relevant_lesson].map{|l| l.id}
        end
      end

      context "type filter is set" do
        context "type filter is 'question'" do
          let(:type) { 'question' }

          it 'returns no lessons' do
            FactoryGirl.create(:lesson)
            expect(search_result.lessons).to match_array []
          end
        end

        context "type filter is anything else" do
          let(:type) { 'challenge' }

          it 'returns no lessons' do
            article = FactoryGirl.create(:lesson)
            challenge = FactoryGirl.create(:lesson, type: 'challenge')

            expect(search_result.lessons).to match_array [challenge]
          end
        end
      end
    end
  end

  describe '#questions' do
    let(:search_result) { SearchResult.new('javascript', type, nil) }

    context "type filter is not set" do
      let(:type) { nil }

      it "returns the searched questions" do
        matching_question = FactoryGirl.create(:question, title: "How do javascript?")
        FactoryGirl.create(:question, title: "How do Rails?")

        expect(search_result.questions).to match_array [matching_question]
      end

      it "returns questions with relevant answers" do
        question = FactoryGirl.create(:question, title: "This is not important.")
        answer = FactoryGirl.create(:answer, body: "This is about javascript.", question: question)

        expect(search_result.questions.map{|l| l.id}).to match_array [question].map{|l| l.id}
      end
    end

    context "type filter is set to a lesson type" do
      let(:type) { "challenge" }

      it "returns no questions" do
        FactoryGirl.create(:question, title: "How do javascript?")

        expect(search_result.questions).to match_array []
      end
    end

    context "type filter is set to questions" do
      let(:type) { "question" }

      it "returns the searched questions" do
        question = FactoryGirl.create(:question, title: "How do javascript?")

        expect(search_result.questions).to match_array [question]
      end
    end
  end

  describe '#total' do
    let(:search_result) { SearchResult.new('javascript', type, Guest.new) }

    context "type filter is not set" do
      let(:type) { nil }

      it "returns the total of matching questions + lessons" do
        FactoryGirl.create(:question, title: "How do javascript?")
        FactoryGirl.create(:lesson, title: "This is about Javascript.")

        expect(search_result.total).to eq(2)
      end
    end

    context "type filter is set" do
      let(:type) { "article" }

      it "disregards any filtered-out results" do
        FactoryGirl.create(:question, title: "How do javascript?")
        FactoryGirl.create(:lesson, title: "This is about Javascript.")

        expect(search_result.total).to eq(1)
      end
    end
  end
end
