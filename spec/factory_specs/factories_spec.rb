require "rails_helper"

describe "Factories" do
  FactoryGirl.factories.map(&:name).each do |factory_name|
    it "#{factory_name} is valid" do
      expect(FactoryGirl.build(factory_name)).to be_valid
    end
  end
end
