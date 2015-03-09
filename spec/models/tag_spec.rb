require "rails_helper"

RSpec.describe Tag, type: :model do
  it { should have_many(:lesson_tags) }
  it { should have_many(:lessons) }

  describe ".process_tag_name" do
    it "replaces capital letters with lowercase" do
      tag = FactoryGirl.build(:tag, name: "JQuery")
      tag.save
      expect(tag.name).to eq("jquery")
    end

    it "replaces spaces with dashes" do
      tag = FactoryGirl.build(:tag, name: "ruby on rails")
      tag.save
      expect(tag.name).to eq("ruby-on-rails")
    end

    it "deletes disallowed characters" do
      tag = FactoryGirl.build(:tag, name: "ruby on rails!!!")
      tag.save
      expect(tag.name).to eq("ruby-on-rails")
    end
  end
end
