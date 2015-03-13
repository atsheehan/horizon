require 'rails_helper'

describe SearchesController do
  describe '#index' do
    it 'sets the expect instance variables' do
      search_result = stub(:search_result)
      lessons = stub(:lessons)
      questions = stub(:questions)
      results = stub(:results)

      SearchResult.expects(:new).with('active record', 'challenge', anything).returns(search_result)

      search_result.stubs(:type).returns('challenge')
      search_result.stubs(:lessons).returns(lessons)
      search_result.stubs(:questions).returns(questions)
      search_result.stubs(:total).returns(results)

      get :index, query: 'active record', type: 'challenge'

      expect(assigns(:active_type)).to eq 'challenge'
      expect(assigns(:lessons)).to eq lessons
      expect(assigns(:questions)).to eq questions
      expect(assigns(:results)).to eq results
    end
  end
end
