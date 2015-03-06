require "rails_helper"

feature "admin downloads a submission", %q{

  As an Event Horizon chief black hole explorer,
  I would like to retrieve the 1's and 0's of a
    users submission,
  So that I might extract and execute it locally
    to determine a cosmonaut's success.

} do

  let(:admin) { FactoryGirl.create(:admin) }
  let(:submission) { FactoryGirl.create(:submission_with_file) }

  scenario "admin visits submission page, sees link to download" do
    sign_in_as(admin)
    visit submission_path(submission)
    expect(page).
      to have_link("Download Submission", href: submission.archive.url)
  end
end
