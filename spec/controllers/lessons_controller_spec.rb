require "rails_helper"

describe LessonsController do
  context "api" do
    render_views

    describe "GET index" do
      it "lists the lesson name, type, and slug" do
        lessons = FactoryGirl.create_list(:lesson, 3, type: "challenge")

        get :index, format: :json
        result = JSON.parse(response.body)

        lessons.each do |lesson|
          lesson_info = {
            "title" => lesson.title,
            "slug" => lesson.slug,
            "type" => "challenge"
          }

          expect(result["lessons"]).to include(lesson_info)
        end
      end

      it "filters based on type" do
        challenge = FactoryGirl.create(:lesson, type: "challenge")

        get :index, format: :json, type: "challenge"
        result = JSON.parse(response.body)

        expect(result["lessons"].count).to eq(1)
        expect(result["lessons"][0]["slug"]).to eq(challenge.slug)
      end

      it "filters based on submittable lessons" do
        challenge = FactoryGirl.create(:lesson, type: "challenge")
        exercise = FactoryGirl.create(:lesson, type: "exercise")

        get :index, format: :json, submittable: "1"
        result = JSON.parse(response.body)

        expect(result["lessons"].count).to eq(2)

        slugs = result["lessons"].map { |lesson| lesson["slug"] }
        expect(slugs).to include(challenge.slug)
        expect(slugs).to include(exercise.slug)
      end
    end

    describe "GET show" do
      it "includes the lesson details" do
        lesson = FactoryGirl.create(:lesson)

        get :show, slug: lesson.slug, format: :json
        result = JSON.parse(response.body)

        expect(result["lesson"]["title"]).to eq(lesson.title)
        expect(result["lesson"]["body"]).to eq(lesson.body)
        expect(result["lesson"]["archive_url"]).to eq(lesson.archive.url)
      end
    end
  end
end
