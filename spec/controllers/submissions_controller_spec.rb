require "rails_helper"

describe SubmissionsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:lesson) { FactoryGirl.create(:lesson) }

  context "api" do
    describe "POST create" do
      context "with valid authentication" do
        it "successfully stores the submission" do
          set_auth_headers_for(user)
          post :create, lesson_slug: lesson.slug,
                        submission: { body: "1 + 2 == 4" },
                        format: :json

          expect(Submission.count).to eq(1)
          expect(response).to be_success
        end

        it "responds with 422 on failure" do
          set_auth_headers_for(user)
          post :create, lesson_slug: lesson.slug,
                        submission: { body: "" },
                        format: :json

          expect(Submission.count).to eq(0)
          expect(response.status).to eq(422)
        end
      end

      context "with no authentication" do
        it "fails to save the submission" do
          post :create, lesson_slug: lesson.slug,
                        submission: { body: "1 + 2 == 4" },
                        format: :json

          expect(Submission.count).to eq(0)
        end
      end
    end
  end

  context "web request" do
    describe "POST create" do
      context "as an authenticated user" do
        it "redirects after successful create" do
          session[:user_id] = user.id
          post :create, lesson_slug: lesson.slug,
                        submission: { body: "1 + 2 == 4" }

          expect(Submission.count).to eq(1)
          expect(response).to redirect_to(submission_path(Submission.first))
        end

        it "redirects on failure" do
          session[:user_id] = user.id
          post :create, lesson_slug: lesson.slug,
                        submission: { body: "" }

          expect(Submission.count).to eq(0)
          expect(response).to redirect_to(lesson_submissions_path(lesson))
        end
      end

      context "as a guest" do
        it "redirects without saving" do
          post :create, lesson_slug: lesson.slug,
                        submission: { body: "1 + 2 == 4" }

          expect(Submission.count).to eq(0)
          expect(response).to redirect_to(root_path)
        end
      end
    end

    describe "PUT update" do
      it "prevents non-admin users from marking submissions as featured" do
        submission = FactoryGirl.create(
          :submission, featured: false, user: user
          )

        session[:user_id] = user.id
        put :update, id: submission.id, submission: { featured: true }

        submission.reload
        expect(submission.featured).to eq(false)
      end
    end

    describe "GET show" do
      it "allows access to the submitting user" do
        submission = FactoryGirl.create(:submission, user: user)
        session[:user_id] = user.id

        get :show, id: submission.id
        expect(response).to be_success
      end

      it "denies access unless you've submitted one solution" do
        submission = FactoryGirl.create(:submission, public: true)
        session[:user_id] = user.id

        expect { get :show, id: submission.id }.
          to raise_error(ActionController::RoutingError)
      end

      it "allows access to admins" do
        admin = FactoryGirl.create(:admin)
        session[:user_id] = admin.id

        submission = FactoryGirl.create(:submission)

        get :show, id: submission.id
        expect(response).to be_success
      end

      it "avoids showing other private submissions" do
        other_user_submission = FactoryGirl.create(:submission)
        session[:user_id] = user.id

        expect { get :show, id: other_user_submission.id }.
          to raise_error(ActionController::RoutingError)
      end
    end
  end
end
