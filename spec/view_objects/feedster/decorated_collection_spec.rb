require 'rails_helper'

describe Feedster::DecoratedCollection do
  context 'comment' do
    it 'decorates a comment feed item' do
      feed_item = FactoryGirl.create(:comment).feed_items.first
      collection = Feedster::DecoratedCollection.new([feed_item])

      expected_class = Feedster::CommentCreatedDecorator
      expect(collection.decorate.first).
        to be_kind_of(expected_class)
    end

    it 'raises an exception when there is no decorator mapping for the class' do
      feed_item = FeedItem.new do |feed_item|
        feed_item.subject = Team.new
        feed_item.verb = 'create'
      end
      collection = Feedster::DecoratedCollection.new([feed_item])

      expect(lambda{ collection.decorate }).
        to raise_error(Feedster::DecoratorMappingNotFound)
    end

    it 'raises an exception when there is no decorator map for the verb' do
      feed_item = FeedItem.new do |feed_item|
        feed_item.subject = Comment.new
        feed_item.verb = 'wizardize'
      end
      collection = Feedster::DecoratedCollection.new([feed_item])

      expect(lambda{ collection.decorate }).
        to raise_error(Feedster::DecoratorMappingNotFound)
    end
  end

  context 'assignment' do
    it 'decorates an assignment feed item' do
      team = FactoryGirl.create(:team)
      student = FactoryGirl.create(:user)
      ee = FactoryGirl.create(:user, role: "admin")
      FactoryGirl.create(:team_membership, user: student, team: team)
      assignment = FactoryGirl.create(:assignment, team: team)

      feed_item = assignment.feed_items.first
      collection = Feedster::DecoratedCollection.new([feed_item])

      expected_class = Feedster::AssignmentCreatedDecorator
    end
  end

  context 'announcement' do
    it 'decorates an announcement feed item' do
      team = FactoryGirl.create(:team)
      student = FactoryGirl.create(:user)
      FactoryGirl.create(:team_membership, user: student, team: team)
      announcement = FactoryGirl.create(:announcement, team: team, title: 'New announcement released!')
      feed_item = announcement.feed_items.first

      collection = Feedster::DecoratedCollection.new([feed_item])

      expected_class = Feedster::AnnouncementCreatedDecorator
      expect(collection.decorate.first).
        to be_kind_of(expected_class)
    end
  end
end
