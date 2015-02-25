require "rails_helper"

describe CommentsController do
  let(:submission) { FactoryGirl.create(:submission) }

  describe "POST create" do
    context "web request" do
      it "allows submission owner to comment" do
        session[:user_id] = submission.user.id
        post :create, submission_id: submission.id, comment: { body: "foo" }

        expect(Comment.count).to eq(1)
        expect(response).to redirect_to(submission_path(Submission.first))
      end

      it "prevents other users from commenting" do
        new_user = FactoryGirl.create(:user)
        session[:user_id] = new_user.id

        expect do
          post :create, submission_id: submission.id, comment: { body: "foo" }
        end.to raise_error(ActionController::RoutingError)

        expect(Comment.count).to eq(0)
      end

      it "prevents unauthorized users from commenting" do
        post :create, submission_id: submission.id, comment: { body: "foo" }

        expect(response).to be_a_redirect
        expect(Comment.count).to eq(0)
      end
    end

    context "api" do
      render_views

      it "returns a JSON payload with the comment on success" do
        set_auth_headers_for(submission.user)
        post :create,
          format: :json,
          submission_id: submission.id,
          comment: { body: "foo" }

        expect(response).to be_successful
        body = JSON.parse(response.body)
        expect(body["comment"]["html_body"]).to eq("<p>foo</p>\n")
        expect(body["comment"]["user"]).to eq(submission.user.username)
      end

      it "returns errors on failure" do
        set_auth_headers_for(submission.user)
        post :create,
             format: :json,
             submission_id: submission.id,
             comment: { body: "" }

        expect(response.code).to eq("422")
        body = JSON.parse(response.body)
        expect(body["body"]).to include("can't be blank")
      end
    end
  end
end
